//
//  PDViewController.m
//  Pusher
//
//  Created by Donelle Sanders Jr on 1/2/13.
//  Copyright (c) 2013 The Potter's Den, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PDViewController.h"
#import "PDRepository.h"
#import "PDStreamParser.h"
#import "PDRegistrar.h"
#import "PDSettings.h"


#pragma mark - PDTableViewCell Implementation

@interface PDTableViewCell () {
    BOOL _bInitialized;
}

@property (nonatomic, retain) PDNotificationModel * model;

- (void)displayText;
- (void)displayImage;
- (void)cellWasSwiped:(UISwipeGestureRecognizer *)recognizer;
- (void)resizeView:(UIView *)childView;

@end


@implementation PDTableViewCell
@synthesize model = _model;
@synthesize textLabel, imageView;


- (void)setModel:(PDNotificationModel *)model
{
    _model = model;
    [self setNeedsDisplay];
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    UISwipeGestureRecognizer * swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwiped:)];
	[swipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)];
	
    [self.contentView addGestureRecognizer:swipeRecognizer];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds cornerRadius:4.0f];
    [[UIColor whiteColor] setFill];
    [rectanglePath fill];
    [[UIColor lightGrayColor] setStroke];
    rectanglePath.lineWidth = 2;
    [rectanglePath stroke];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    switch (_model.type) {
        case PDNotificationTypeText:
        {
            [self.imageView setHidden:YES];
            [self displayText];
            [self resizeView:self.textLabel];
            break;
        }
            
        case PDNotificationTypeImage:
        {
            [self.textLabel setHidden:YES];
            [self displayImage];
            [self resizeView:self.imageView];
            break;
        }
            
        case PDNotificationTypeBoth:
        {
            /* Decided not to implement this one */
            break;
        }
    }
    
    
}

#pragma mark - Instance Methods


-(void)cellWasSwiped:(UISwipeGestureRecognizer *)recognizer
{
    [[PDRepository sharedInstance] deleteNotification:_model];
}


- (void)displayText
{
    NSString * text = [PDStreamParser stringFromData:_model.content];
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(293, 400)];
    CGRect bounds = self.textLabel.bounds;
    
    [self.textLabel setHidden:NO];
    [self.textLabel setText:text];
    [self.textLabel setBounds:CGRectMake(0, 0, bounds.size.width, textSize.height)];
}

- (void)displayImage
{
    [self.imageView setHidden:NO];
    [self.imageView setImage:[PDStreamParser imageFromData:_model.content]];
    [self.imageView setBounds:CGRectMake(0, 0, 293, 200)];
}

- (void)resizeView:(UIView *)childView
{
    CGSize widthHeight = childView.bounds.size;
    [childView setFrame:CGRectMake(9, 12, widthHeight.width, widthHeight.height)];
    
    CGRect rcCell = self.contentView.frame;
    rcCell.size = CGSizeMake(rcCell.size.width, childView.frame.origin.y + widthHeight.height + 10);
    [self.contentView setFrame:rcCell];

}

@end



#pragma mark - PDViewController Implementation

@interface PDViewController () <NSFetchedResultsControllerDelegate,UIAlertViewDelegate,PDRegistrarDelegate> {
    UIView * _loadingView;
}

@property (nonatomic, retain) NSFetchedResultsController * notificationController;
@property (nonatomic, retain) PDRegistrar * registrar;
@property (nonatomic, readonly) UIView * loadingView;

-(void)showLoadingView;
-(void)hideLoadingView;

@end


@implementation PDViewController

@synthesize notificationController = _notificationController;
@synthesize notificationView = _notificationView;
@synthesize registrar = _registrar;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.notificationController = [[PDRepository sharedInstance] createRepositoryController:self];
    self.registrar = [[PDRegistrar alloc] init];
    self.registrar.delegate = self;
    
    NSError * errors = nil;
    if(![_notificationController performFetch:&errors]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Pusher"
                                                         message:@"An error occured loading your data please restart this app"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionFailure)
                                                 name:PDNotificationOpenConnectionFailure
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataFailure)
                                                 name:PDNotificationRecieveDataFailure
                                               object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.notificationController = nil;
    self.registrar = nil;
}



#pragma mark - UITableView Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> info = [[_notificationController sections] objectAtIndex:section];
    return [info numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 9.0f; /* The nine value is the y axis point for both controls on the cell */
    CGFloat padding = 20.0f;
    
    PDNotificationModel * model = [_notificationController objectAtIndexPath:indexPath];
    switch (model.type) {
        case PDNotificationTypeText:
        {
            NSString * text = [PDStreamParser stringFromData:model.content];
            CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(293, 400)];
            height += textSize.height + padding;
            break;
        }
            
        case PDNotificationTypeImage:
        {
            UIImage * image = [PDStreamParser imageFromData:model.content];
            height += image.size.height + padding;
            break;
        }
            
        case PDNotificationTypeBoth:
        {
            /* Decided not to implement this one */
            break;
        }
    }
    
    return height;
}


#pragma mark - UITableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    PDTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[PDTableViewCell alloc] init];
    
    cell.model = [_notificationController objectAtIndexPath:indexPath];
    return cell;
}



#pragma mark - NSFetchedResultController Delegate

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [_notificationView insertRowsAtIndexPaths:@[newIndexPath]
                                     withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [_notificationView deleteRowsAtIndexPaths:@[indexPath]
                                     withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}


#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString * host = [alertView textFieldAtIndex:0].text;
        NSArray * components = [host componentsSeparatedByString:@":"];
        if (components.count  == 1)
            host = [NSString stringWithFormat:@"%@:12345", host];

        [self showLoadingView];
        [_registrar registerWith:host];
    }
    
}


#pragma mark - PDRegistrarDelegate Methods

- (void)registrarDidRegister
{
    [self hideLoadingView];
}


- (void)registrarFailedWith:(NSError *)error
{
    [self hideLoadingView];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Server Error"
                                                     message:@"An error occured trying to connect to the server please try again."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
}


#pragma mark - UI Events

- (IBAction)didClickSetup:(id)sender
{
    UIAlertView * serverSetup = [[UIAlertView alloc] initWithTitle:@"Connect to Host"
                                                           message:@"Enter the server information to register"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Register", nil];
    
    serverSetup.alertViewStyle = UIAlertViewStylePlainTextInput;
    [serverSetup textFieldAtIndex:0].placeholder = @"hostname or hostname:port";
    [serverSetup show];
}


#pragma mark - Instance Methods

-(UIView *)loadingView
{
    if (_loadingView != nil)
        return _loadingView;
    
    CGRect frame = self.view.frame;
    if (self.navigationController != nil)
        frame = self.navigationController.view.frame;
    
    int yPos = (frame.size.height / 2) - 23;
    UIView * innerContainer = [[UIView alloc] initWithFrame:CGRectMake(90, yPos, 145, 55)];
    innerContainer.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0];
    innerContainer.layer.cornerRadius = 5;
    
    UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicator setFrame:CGRectMake(9, 19, 20, 20)];
    [indicator startAnimating];
    [innerContainer addSubview:indicator];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(37, 19, 96, 21)];
    label.text = @"Please wait..";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [innerContainer addSubview:label];
    
    _loadingView = [[UIView alloc] initWithFrame:frame];
    _loadingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4300];
    [_loadingView addSubview:innerContainer];
    [self.view addSubview:_loadingView];
    
    return _loadingView;
}


-(void)showLoadingView
{
    [self.loadingView setAlpha:0.0];
    [self.loadingView setHidden:NO];
    
    [UIView transitionWithView:self.loadingView
                      duration:1.0
                       options:UIViewAnimationCurveEaseInOut
                    animations:^() { [self.loadingView setAlpha:1.0]; } completion:nil];
}

-(void)hideLoadingView
{
    [UIView transitionWithView:self.loadingView
                      duration:1.0
                       options:UIViewAnimationCurveEaseInOut
                    animations:^() {
                        [self.loadingView setAlpha:0.0];
                    }
                    completion:^(BOOL b){
                        [self.loadingView setHidden:NO];
                    }];
}

- (void)connectionFailure
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                     message:@"It appears that your network connection is down restart the app"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];

}

- (void)dataFailure
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                     message:@"An error occurred recieving data from the host"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
}


@end
