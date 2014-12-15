//
//  VacanciesTableViewCell.m
//  HeadHunterTestApp
//
//  Created by Roman Fedyanin on 10/12/14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "VacanciesTableViewCell.h"

@implementation VacanciesTableViewCell

-(void)awakeFromNib {
    //Длинные названия должны влезть
    self.vacancyNameLabel.numberOfLines = IPAD ? 3 : 4;
    
    self.vacancyNameLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:IPAD ? 22 : 17];
    self.companyNameLabel.font = [UIFont fontWithName:@"ArialMT" size:IPAD ? 17 : 12];
    self.salaryLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:IPAD ? 17 : 12];
    
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    [self.companyLogoImageView prepareForReuse];
    
}

@end
