package main

import (
	_ "database/sql"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/nfraenkel/lunch/Godeps/_workspace/src/github.com/jmoiron/sqlx"
	_ "github.com/nfraenkel/lunch/Godeps/_workspace/src/github.com/lib/pq"
	"github.com/nfraenkel/lunch/Godeps/_workspace/src/github.com/zenazn/goji"
	"github.com/nfraenkel/lunch/Godeps/_workspace/src/github.com/zenazn/goji/web"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"sort"
	"time"
)

type Server struct {
	db   *sqlx.DB
	port string
}

var server Server

type ApiHandlerFunc func(web.C, http.ResponseWriter, *http.Request) (int, error)

func ApiHandler(h ApiHandlerFunc) web.HandlerFunc {
	return web.HandlerFunc(func(c web.C, w http.ResponseWriter, r *http.Request) {
		code, err := h(c, w, r)
		if err != nil {
			http.Error(w, err.Error(), code)
		} else {
			w.WriteHeader(code)
		}
	})
}

func initServer() {
	var migrationsFolder string
	var dbUrl string
	var migrationSql = `
	CREATE TABLE IF NOT EXISTS migrations (
		id SERIAL PRIMARY KEY,
		name TEXT NOT NULL UNIQUE,
		created TIMESTAMP without time zone default (now() at time zone 'utc') 
	)`

	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
		dbUrl = devDb
	} else {
		dbUrl = os.Getenv("DATABASE_URL")
	}
	flag.Set("bind", ":"+port)
	serverDir, err := filepath.Abs(filepath.Dir(os.Args[0]))
	if err != nil {
		log.Fatal(err)
	}
	migrationsFolder = filepath.Join(serverDir, "./migrations")

	db, err := sqlx.Connect("postgres", dbUrl)
	if err != nil {
		log.Fatal(err)
	}
	Log("executing migrations\n")
	server.db = db
	server.db.MustExec(migrationSql)

	d, err := os.Open(migrationsFolder)
	if err != nil {
		log.Fatal(err)
	}
	dir, err := d.Readdir(-1)
	if err != nil {
		log.Fatal(err)
	}

	sqlFiles := make([]string, 0)
	for _, f := range dir {
		ext := filepath.Ext(f.Name())
		if ".sql" == ext {
			sqlFiles = append(sqlFiles, f.Name())
		}
	}
	sort.Strings(sqlFiles)
	for _, filename := range sqlFiles {
		migrated, err := HasMigrated(filename)
		if err != nil {
			server.db.Close()
			log.Fatal(err)
		}
		fullpath := filepath.Join(migrationsFolder, filename)
		if migrated {
			continue
		}
		b, err := ioutil.ReadFile(fullpath)
		if err != nil {
			server.db.Close()
			log.Fatal(err)
		}
		migration := string(b)
		if len(migration) == 0 {
			Log(fmt.Sprintf("skipping empty file %s", filename))
			continue
		}
		server.db.MustExec(migration)
		server.db.MustExec("INSERT INTO migrations (name) values ($1)", filename)
		Log(fmt.Sprintf("migrated file %s", filename))
	}

	if err != nil {
		server.db.Close()
		log.Fatal(err)
	}

}

func HasMigrated(filename string) (bool, error) {
	var count int
	err := server.db.QueryRow("select count(1) from migrations where name = $1", filename).Scan(&count)
	if err != nil {
		return false, err
	}
	return count > 0, nil
}

type User struct {
	Id      int       `db:"user_id" param:"user_id" json:"id"`
	First   string    `db:"user_first" param:"user_first" json:"first_name"`
	Last    string    `db:"user_last" param:"user_last" json:"last_name"`
	Email   string    `db:"user_email" param:"user_email" json:"email"`
	Photo   string    `db:"user_photo" param:"user_photo" json:"photo"`
	Created time.Time `db:"user_created" param:"user_created" json:"created"`
}

func GetUser(email string) (*User, error) {
	u := &User{Email: email}
	err := server.db.QueryRow(`
		SELECT 
		user_id, user_first_name, user_last_name, user_photo
		FROM users WHERE user_email = $1`, u.Email).Scan(&u.Id, &u.First, &u.Last, &u.Photo)
	return u, err
}

type Venue struct {
	Id       int       `db:"venue_id" param:"venue_id" json:"id"`
	Name     string    `db:"venue_name" param:"venue_name" json:"name"`
	Photo    string    `db:"venue_photo" param:"venue_photo" json:"photo"`
	Location string    `db:"venue_location" param:"venue_location" json:"location"`
	Type     string    `db:"venue_type" param:"venue_type" json:"type"`
	Created  time.Time `db:"venue_created" param:"venue_created" json:"created"`
}

func (v *Venue) Create() error {
	return server.db.QueryRow(`
		INSERT INTO venues 
			(venue_name, venue_location, venue_type, venue_created)
			VALUES ($1, $2, $3, $4) RETURNING venue_id
		`, v.Name, v.Location, v.Type, time.Now().UTC()).Scan(&v.Id)
}

type Choice struct {
	User    int       `db:"user_id" param:"user_id" json:"user_id"`
	Venue   int       `db:"venue_id" param:"venue_id" json:"venue_id"`
	Created time.Time `db:"choice_created" param:"choice_created" json:"created"`
}

func (c *Choice) Create() error {
	_, err := server.db.Exec(`DELETE FROM choices WHERE user_id = $1`, c.User)
	if err != nil {
		return err
	}
	return server.db.QueryRow(`
		INSERT INTO choices 
			(user_id, venue_id)
			VALUES ($1, $2) RETURNING choice_created
		`, c.User, c.Venue).Scan(&c.Created)
}

type LoginPayload struct {
	Email string `json:"email"`
}

func Login(c web.C, w http.ResponseWriter, r *http.Request) (int, error) {
	var err error
	l := &LoginPayload{}
	decoder := json.NewDecoder(r.Body)
	if err = decoder.Decode(l); err != nil {
		return http.StatusNotAcceptable, err
	}
	u, err := GetUser(l.Email)
	if err != nil {
		return http.StatusInternalServerError, err
	}
	return respond(w, u)
}

func GetVenuesWithChoices(c web.C, w http.ResponseWriter, r *http.Request) (int, error) {
	var buf []byte
	getVenuesSql := `
		SELECT json_agg(x) from (
			SELECT
				v.venue_id as id,
				v.venue_name as name,
				v.venue_location as location,
				v.venue_type as type,
				v.venue_photo as photo,
				(SELECT coalesce(
					json_agg(
						json_build_object(
							'id', u.user_id,
							'first_name', u.user_first_name,
							'email', u.user_email,
							'last_name', u.user_last_name,
							'photo', u.user_photo
							)
						),
						json'[]')
					FROM users u
					JOIN choices c USING (user_id)
					WHERE c.venue_id = v.venue_id
				) users
			FROM venues v
		) x;
	`
	rows, err := server.db.Query(getVenuesSql)
	if err != nil {
		return http.StatusInternalServerError, err
	}
	for rows.Next() {
		rows.Scan(&buf)
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write(buf)
	return http.StatusOK, nil
}

func hello(c web.C, w http.ResponseWriter, r *http.Request) (int, error) {
	fmt.Fprintf(w, "Hello, %s!", c.URLParams["name"])
	return http.StatusOK, nil
}

func respond(w http.ResponseWriter, v interface{}) (int, error) {
	w.Header().Set("Content-Type", "application/json")
	buf, err := json.Marshal(v)
	if err != nil {
		return http.StatusInternalServerError, err
	}
	w.Write(buf)
	return http.StatusOK, nil
}

func CreateVenue(c web.C, w http.ResponseWriter, r *http.Request) (int, error) {
	venue := &Venue{}
	var err error
	decoder := json.NewDecoder(r.Body)
	if err = decoder.Decode(venue); err != nil {
		return http.StatusNotAcceptable, err
	}
	if err = venue.Create(); err != nil {
		return http.StatusInternalServerError, err
	}
	w.Header().Set("Content-Type", "application/json")
	buf, _ := json.Marshal(venue)
	w.Write(buf)
	return http.StatusOK, nil
}

func CreateChoice(c web.C, w http.ResponseWriter, r *http.Request) (int, error) {
	choice := &Choice{}
	var err error
	decoder := json.NewDecoder(r.Body)
	if err = decoder.Decode(choice); err != nil {
		return http.StatusNotAcceptable, err
	}
	if err = choice.Create(); err != nil {
		return http.StatusInternalServerError, err
	}
	w.Header().Set("Content-Type", "application/json")
	buf, _ := json.Marshal(choice)
	w.Write(buf)
	return http.StatusOK, nil
}

func main() {
	initServer()
	goji.Get("/hello/:name", ApiHandler(hello))
	goji.Post("/api/login", ApiHandler(Login))
	goji.Get("/api/venues", ApiHandler(GetVenuesWithChoices))
	goji.Post("/api/venues", ApiHandler(CreateVenue))
	goji.Post("/api/choices", ApiHandler(CreateChoice))
	goji.Serve()
}

func Log(message string) {
	fmt.Println(message)
}
