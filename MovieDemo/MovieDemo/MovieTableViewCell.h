//
//  MovieTableViewCell.h
//  MovieDemo
//
//  Created by Hugo Aguero on 10/1/15.
//  Copyright © 2015 Hugo Aguero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;

@end
