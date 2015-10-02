//
//  FeedViewController.m
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

@synthesize singleton, segmentedControl, choices;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.singleton = [LunchSingleton sharedDataModel];
    
    UIColor *brandOrange = [UIColor colorWithRed:241.0f/255.0f green:92.0f/255.0f blue:37.0f/255.0f alpha:1.0f];
    UIColor *darkOrange = [UIColor colorWithRed:215.0f/255.0f green:80.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
    
    // SEGMENTED CONTROL
    [self.segmentedControl addTarget:self
                              action:@selector(segmentSwitch:)
                    forControlEvents:UIControlEventValueChanged];
    
    // SCREEN SIZE
    totalSize = 0;
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    // PROFILE PIC
    NSInteger offset = 50;
    NSInteger picSize = 30;
    UIImageView *profilePhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - picSize - 20, offset + segmentedControl.frame.origin.y, picSize, picSize)];
    UIImage *profPic = [self imageFromURLString:self.singleton.user.photoUrl];
    [profilePhotoImageView setImage:profPic];
    profilePhotoImageView.layer.cornerRadius = 15;
    profilePhotoImageView.layer.masksToBounds = YES;
    [self.view addSubview:profilePhotoImageView];
    
    // BIG VIEW / SCROLL VIEW
    CGRect bigViewFrame = CGRectMake(0, offset + segmentedControl.frame.size.height, screenWidth, screenHeight - segmentedControl.frame.size.height - offset);
    sv = [[UIScrollView alloc] initWithFrame:bigViewFrame];
    sv.delegate = self;
    [sv setBackgroundColor:darkOrange];
    [self.view addSubview:sv];
    
    // seperator
    UIView *seperatorTop = [[UIView alloc] initWithFrame:CGRectMake(0, bigViewFrame.origin.y, screenWidth, 1)];
    [seperatorTop setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:seperatorTop];
    
    // orange top background
    CGRect orangeBGTopFrame = CGRectMake(0, 0, screenWidth, 280);
    UIView *orangeBGTop = [[UIView alloc] initWithFrame:orangeBGTopFrame];
    [orangeBGTop setBackgroundColor:brandOrange];
    [sv addSubview:orangeBGTop];
    
    // greeting label
    CGRect greetingLabelFrame = CGRectMake(0, 150, screenWidth, 40);
    UILabel *greetingLabel = [[UILabel alloc] initWithFrame:greetingLabelFrame];
    [greetingLabel setText:[NSString stringWithFormat:@"Hungry, %@?", self.singleton.user.first]];
    greetingLabel.textAlignment = NSTextAlignmentCenter;
    [greetingLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:32.0f]];
    [greetingLabel setTextColor:[UIColor whiteColor]];

    // date
    CGRect lunchForFrame = CGRectMake(0, 10, screenWidth, 20);
    UILabel *lunchFor = [[UILabel alloc] initWithFrame:lunchForFrame];
    [lunchFor setText:[NSString stringWithFormat:@"Lunch for"]];
    lunchFor.textAlignment = NSTextAlignmentCenter;
    [lunchFor setTextColor:[UIColor whiteColor]];
    [lunchFor setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];

    CGRect dateLabelFrame = CGRectMake(0, 32, screenWidth, 20);
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateLabelFrame];
    [dateLabel setText:[NSString stringWithFormat:@"Friday, October 2"]];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [dateLabel setTextColor:[UIColor whiteColor]];
    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
    
    CGRect promptLabelFrame = CGRectMake(80, 190, screenWidth - 160, 50);
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:promptLabelFrame];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.numberOfLines = 2;
    [promptLabel setText:[NSString stringWithFormat:@"See where your coworkers are going for lunch"]];
    [promptLabel setTextColor:[UIColor whiteColor]];
    [promptLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    
    NSInteger foodSize = 50;
    UIImageView *food1 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 80, foodSize, foodSize)];
    [food1 setImage:[UIImage imageNamed:@"icon-food-1.png"]];
    UIImageView *food2 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 200, foodSize, foodSize)];
    [food2 setImage:[UIImage imageNamed:@"icon-food-2.png"]];
    UIImageView *food3 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2 - foodSize/2, 75, foodSize, foodSize)];
    [food3 setImage:[UIImage imageNamed:@"icon-food-3.png"]];
    UIImageView *food4 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 30 - foodSize, 80, foodSize, foodSize)];
    [food4 setImage:[UIImage imageNamed:@"icon-food-4.png"]];
    UIImageView *food5 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 30 - foodSize, 200, foodSize, foodSize)];
    [food5 setImage:[UIImage imageNamed:@"icon-food-5.png"]];
    
    [orangeBGTop addSubview:greetingLabel];
    [orangeBGTop addSubview:lunchFor];
    [orangeBGTop addSubview:dateLabel];
    [orangeBGTop addSubview:promptLabel];
    [orangeBGTop addSubview:food1];
    [orangeBGTop addSubview:food2];
    [orangeBGTop addSubview:food3];
    [orangeBGTop addSubview:food4];
    [orangeBGTop addSubview:food5];
    
    totalSize = orangeBGTopFrame.origin.y + orangeBGTopFrame.size.height;
    sv.contentSize = CGSizeMake(screenWidth, totalSize);
    
    // TABLE VIEW
    tv = [[UITableView alloc] initWithFrame:bigViewFrame];
    tv.hidden = YES;
    tv.delegate = self;
    tv.dataSource = self;
    
    // CONFIRMATION VIEW
    cv = [[UIView alloc] initWithFrame:bigViewFrame];
    cv.hidden = YES;
    

    // END
    [self.view addSubview:tv];
    [self.view addSubview:cv];

    [self fetchChoicesForToday];
    [self fetchChoicesForYesterday];
}

-(void)fetchChoicesForToday {
    GetChoicesCommand *cmd = [[GetChoicesCommand alloc] init];
    cmd.delegate = self;
    [cmd fetchChoices];
}

-(void)fetchChoicesForYesterday {
    GetHistoryCommand *cmd = [[GetHistoryCommand alloc] init];
    cmd.delegate = self;
    [cmd fetchHistory];
}


- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *sc = (UISegmentedControl *) sender;
    NSInteger selectedSegment = sc.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        if (confirmationScreen) {
            [cv setHidden:NO];
        }
        else {
            [sv setHidden:NO];
        }
        [tv setHidden:YES];
    }
    else{
        //toggle the correct view to be visible
        if (confirmationScreen) {
            [cv setHidden:YES];
        }
        else {
            [sv setHidden:YES];
        }
        [tv setHidden:NO];
    }
}

-(void)refreshUI {
    
    UIColor *darkOrange = [UIColor colorWithRed:215.0f/255.0f green:80.0f/255.0f blue:30.0f/255.0f alpha:1.0f];

    for (int i = 0; i < [self.choices count]; i++) {
        Choice *ch = (Choice*)[self.choices objectAtIndex:i];
        
        NSInteger rowHeight = 135;
        CGRect rowViewFrame = CGRectMake(20, totalSize + 20, screenWidth - 40, rowHeight);
        totalSize += rowHeight;
        
        UIView *rowView = [[UIView alloc] initWithFrame:rowViewFrame];
        rowView.layer.cornerRadius = 5;
        rowView.layer.masksToBounds = YES;
        [rowView setBackgroundColor:[UIColor whiteColor]];
        
        NSInteger height1 = 15;
        
        UIImage *image = [self imageFromURLString:ch.venue.photoUrl];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, height1, 40, 40)];
        [imageView setImage:image];
        imageView.layer.cornerRadius = imageView.frame.size.height/2;
        imageView.layer.masksToBounds = YES;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, height1, screenWidth - 50, 20)];
        [nameLabel setText:ch.venue.name];
        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
        
        UILabel *subHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, height1 + 20, screenWidth - 50, 20)];
        NSString *category = ch.venue.type;
        NSString *distance = ch.venue.distance;
        [subHeaderLabel setText:[NSString stringWithFormat:@"%@ - %@ miles away", category, distance]];
        [subHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
        [subHeaderLabel setTextColor:[UIColor lightGrayColor]];
        
        UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(10, rowHeight / 2, rowViewFrame.size.width - 20, 1)];
        [seperator setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f]];
        
        // users
        NSArray *users = ch.users;
        UILabel *usersGoingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, screenWidth - 20, 20)];
        NSString *usersText = NULL;
        if ([users count] == 0) {
            usersText = @"No one is going yet. Lead the way!";
        }
        else {
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 10, 20)];
            [numberLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f]];
            [numberLabel setTextColor:darkOrange];
            [numberLabel setText:[NSString stringWithFormat:@"%lu", [users count]]];
            [rowView addSubview: numberLabel];
            
            usersText = @"of your coworkers are going";
            [usersGoingLabel setFrame:CGRectMake(35, 90, screenWidth - 20, 20)];
        }
        [usersGoingLabel setText:usersText];
        [usersGoingLabel setTextColor:[UIColor lightGrayColor]];
        [usersGoingLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
        [rowView addSubview:usersGoingLabel];
        
        UIColor *darkOrange = [UIColor colorWithRed:215.0f/255.0f green:80.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
        CGRect buttonFrame = CGRectMake(rowViewFrame.size.width - 70, 87.5, 60, 30);
        UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeSystem];
        joinButton.tag = i;
        [joinButton setFrame:buttonFrame];
        [joinButton setTitle:@"Let's Go" forState:UIControlStateNormal];
        [joinButton setTitleColor:darkOrange forState:UIControlStateNormal];
        [joinButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
        joinButton.layer.borderColor = darkOrange.CGColor;
        joinButton.layer.borderWidth = 1.0f;
        joinButton.layer.cornerRadius = 5;
        joinButton.layer.masksToBounds = YES;
        joinButton.reversesTitleShadowWhenHighlighted = YES;
        [joinButton addTarget:self
                       action:@selector(joinLunch:)
             forControlEvents:UIControlEventTouchUpInside];
        
        [rowView addSubview:imageView];
        [rowView addSubview:nameLabel];
        [rowView addSubview:subHeaderLabel];
        [rowView addSubview:seperator];
        [rowView addSubview:joinButton];
        
        [sv addSubview:rowView];
        
        totalSize += 20;
        sv.contentSize = CGSizeMake(screenWidth, totalSize);
    }
    totalSize += 20;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)joinLunch:(UIButton *)sender {
    NSInteger num = sender.tag;
    
    Choice *ch = [self.choices objectAtIndex:num];
    
    self.singleton.currentVenue = ch.venue;
    self.singleton.otherUsers = ch.users;
    
    // join choice
    JoinChoiceCommand *cmd = [[JoinChoiceCommand alloc] initWithUser:self.singleton.user andVenue:ch.venue];
    cmd.delegate = self;
    [cmd joinChoice];
}

-(void)makeConfirmationView {
    for (UIView *subview in [cv subviews]) {
        [subview removeFromSuperview];
    }
    
    UIScrollView *scrolley = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 80)];
    scrolley.delegate = self;
    
    NSInteger runningTotal = 0;
    
    NSInteger margin = 60;
    NSInteger buttonHeight = 60;
    UIColor *darkOrange = [UIColor colorWithRed:215.0f/255.0f green:80.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
    
    Venue *venue = self.singleton.currentVenue;
    NSInteger venueImageSize = 60;
    UIImageView *venueImageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - venueImageSize)/2, 40, venueImageSize, venueImageSize)];
    [venueImageView setImage:[self imageFromURLString:venue.photoUrl]];
    venueImageView.layer.cornerRadius = venueImageView.frame.size.height/2;
    venueImageView.layer.masksToBounds = YES;
    [scrolley addSubview:venueImageView];
    
    // you're going to
    UILabel *goingWithLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, screenWidth, 30)];
    [goingWithLabel setText:@"You're going to"];
    [goingWithLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0f]];
    [goingWithLabel setTextColor:[UIColor lightGrayColor]];
    [goingWithLabel setTextAlignment:NSTextAlignmentCenter];
    [scrolley addSubview:goingWithLabel];
    
    // venue at 12:30
    UILabel *venueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, screenWidth, 30)];
    [venueLabel setText:[NSString stringWithFormat:@"%@ at 12:30", venue.name]];
    [venueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0f]];
    [venueLabel setTextAlignment:NSTextAlignmentCenter];
    [scrolley addSubview:venueLabel];
    runningTotal += venueLabel.frame.origin.y + venueLabel.frame.size.height + 20;
    
    if ([self.singleton.otherUsers count] == 0) {
        UILabel *emptyStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, runningTotal + 20, screenWidth, 30)];
        [emptyStateLabel setText:@"Tell your friends to join you!"];
        emptyStateLabel.textAlignment = NSTextAlignmentCenter;
        [emptyStateLabel setTextColor:[UIColor lightGrayColor]];
        [emptyStateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0f]];
        [scrolley addSubview:emptyStateLabel];
        
        runningTotal = emptyStateLabel.frame.origin.y + emptyStateLabel.frame.size.height + 40;
    }
    else {
        UILabel *withLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, screenWidth, 30)];
        [withLabel setText:@"with"];
        [withLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0f]];
        [withLabel setTextAlignment:NSTextAlignmentCenter];
        [withLabel setTextColor:[UIColor lightGrayColor]];
        [scrolley addSubview:withLabel];
        runningTotal = withLabel.frame.origin.y + withLabel.frame.size.height + 20;
        
        NSInteger midpoint = screenWidth/2;
        NSInteger height = 40;
        for (User *u in self.singleton.otherUsers) {
            UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(midpoint - height - 20, runningTotal, height, height)];
            [userImageView setImage:[self imageFromURLString:u.photoUrl]];
            userImageView.layer.cornerRadius = userImageView.frame.size.height/2;
            userImageView.layer.masksToBounds = YES;
            
            UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(midpoint, runningTotal, midpoint, height)];
            [userLabel setText:u.first];
            [userLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:22.0f]];
            
            [scrolley addSubview:userImageView];
            [scrolley addSubview:userLabel];
            
            runningTotal += height + 20;
        }
    }
    
    runningTotal += 20;
    
    UIButton *openMapsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [openMapsButton setFrame:CGRectMake(margin, runningTotal, screenWidth - (2*margin), buttonHeight)];
    [openMapsButton setTitle:@"Open in Maps?" forState:UIControlStateNormal];
    [openMapsButton setTitleColor:darkOrange forState:UIControlStateNormal];
    openMapsButton.layer.cornerRadius = 5;
    openMapsButton.layer.borderColor = darkOrange.CGColor;
    openMapsButton.layer.borderWidth = 1.0f;
    openMapsButton.layer.masksToBounds = YES;
    openMapsButton.reversesTitleShadowWhenHighlighted = YES;
    [openMapsButton addTarget:self
                       action:@selector(openInMaps:)
             forControlEvents:UIControlEventTouchUpInside];
    [scrolley addSubview:openMapsButton];
    runningTotal += buttonHeight + 20;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setFrame:CGRectMake(margin, runningTotal, screenWidth - (2*margin), buttonHeight)];
    [cancelButton setTitle:@"Go somewhere else?" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithWhite:0.8f alpha:1.0f] forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 5;
    cancelButton.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    cancelButton.layer.borderWidth = 1.0f;
    cancelButton.layer.masksToBounds = YES;
    cancelButton.reversesTitleShadowWhenHighlighted = YES;
    [cancelButton addTarget:self
                     action:@selector(cancelLunch:)
           forControlEvents:UIControlEventTouchUpInside];
    [scrolley addSubview:cancelButton];
    runningTotal += buttonHeight + 40;

    scrolley.contentSize = CGSizeMake(screenWidth, runningTotal);
    
    [cv addSubview:scrolley];

}

-(void)openInMaps:(UIButton *)sender {
    NSLog(@"OPEN IN MAPS!!");
}

-(void)cancelLunch:(UIButton *)sender {
    NSLog(@"CANCELLING");
    
    DeleteJoinCommand *cmd = [[DeleteJoinCommand alloc] initWithUser:self.singleton.user];
    cmd.delegate = self;
    [cmd deleteJoin];
}

-(void)reactToDeleteJoinError:(NSError *)error {
    NSLog(@"DELETE JOINE RRRROORORRR :( : %@", error);
}

-(void)reactToDeleteJoinResponse {
    [sv setHidden:NO];
    [cv setHidden:YES];
    confirmationScreen = NO;
}

-(void)reactToGetChoicesError:(NSError *)error {
    NSLog(@"ERRORRRRRRR: %@", error);
}

-(void)reactToGetChoicesResponse:(NSMutableArray *)array {
    self.choices = array;
    [self refreshUI];
}

-(void)reactToGetHistoryError:(NSError *)error {
    NSLog(@"OH NO ERROR :(: %@", error);
}

-(void)reactToGetHistoryResponse:(NSMutableArray *)array {
    self.history = array;
    [tv reloadData];
}

-(void)reactToJoinChoiceError:(NSError *)error {
    NSLog(@"jOIN CHOICE ERRORORORRRRR");
}

-(void)reactToJoinChoiceResponse {
    [self makeConfirmationView];
    
    [sv setHidden:YES];
    [cv setHidden:NO];
    confirmationScreen = YES;
}

- (UIImage *)imageFromURLString:(NSString *)urlString {
    NSURL *imageURL = [NSURL URLWithString:urlString];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.history count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Choice *ch = [self.history objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"historyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIImageView *venueImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [venueImageView setImage:[self imageFromURLString:ch.venue.photoUrl]];
        venueImageView.layer.cornerRadius = venueImageView.frame.size.height/2;
        venueImageView.layer.masksToBounds = YES;
        [cell addSubview:venueImageView];
        
        NSString *text = @"";
        for (int i = 0; i < [ch.users count]; i++) {
            User *u = [ch.users objectAtIndex:i];
            if (i == [ch.users count] - 1) {
                text = [text stringByAppendingString:[NSString stringWithFormat:@"and %@", u.first]];
            }
            else {
                text = [text stringByAppendingString:[NSString stringWithFormat:@"%@, ", u.first]];
            }
        }
        text = [text stringByAppendingString:[NSString stringWithFormat:@" had lunch at %@", ch.venue.name]];
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, screenWidth - 60, 30)];
        [tLabel setText:text];
        [cell addSubview:tLabel];
    }
    
    return cell;
}


@end
