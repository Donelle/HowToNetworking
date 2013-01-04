//
//  PDViewController.h
//  Pusher
//
//  Created by Donelle Sanders Jr on 1/2/13.
//  Copyright (c) 2013 The Potter's Den, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@interface PDViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *notificationView;

@end
