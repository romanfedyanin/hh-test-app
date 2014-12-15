//
//  VacanciesTableViewCell.h
//  HeadHunterTestApp
//
//  Created by Roman Fedyanin on 10/12/14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLImageView.h"

@interface VacanciesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *vacancyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salaryLabel;
@property (weak, nonatomic) IBOutlet URLImageView *companyLogoImageView;

@end
