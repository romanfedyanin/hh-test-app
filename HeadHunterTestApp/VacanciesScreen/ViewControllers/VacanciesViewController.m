//
//  VacanciesViewController.m
//  HeadHunterTestApp
//
//  Created by Roman Fedyanin on 10/12/14.
//  Copyright (c) 2014 Roman. All rights reserved.
//

#import "VacanciesViewController.h"
#import "VacanciesTableViewCell.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkReachabilityManager.h"
#import "Vacancy.h"
#import "SalaryStringBuilder.h"
#import "MBProgressHUD.h"

static NSInteger const kVacanciesPerPage = 20;
static NSInteger const kVacanciesTableViewRowHeight = 150;

@implementation VacanciesViewController {
    // текущий сет для загрузки
    NSInteger _currentSet;
    // массив вакансий
    NSMutableArray *_vacancies;
    // догружаются ли в данный момент вакансии
    BOOL _isLoading;
}

#pragma mark - Lifecycle

-(void)awakeFromNib {
    [self initialSetup];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _vacanciesTableView.hidden = YES;
    _vacanciesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadDictionariesForSalaryDisplay];
    [self loadNextVacanciesSet];
}

#pragma mark - Private methods

-(void)initialSetup {
    _vacancies = [NSMutableArray array];
    _isLoading = NO;
    _currentSet = 0;
}

-(void)loadNextVacanciesSet {
    [self addSpinnerToFooter];
    NSString *string = [NSString stringWithFormat:@"https://api.hh.ru/vacancies?per_page=%@&page=%@", @(kVacanciesPerPage), @(_currentSet)];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self removeSpinnerFromFooter];
        if (![responseObject isKindOfClass:[NSDictionary class]])
            return;
        
        NSArray *items = responseObject[@"items"];
        for (NSDictionary *itemDict in items) {
            Vacancy *newVacancy = [[Vacancy alloc] init];
            newVacancy.vacancyId = itemDict[@"id"];
            NSPredicate *vacancyIdPredicate = [NSPredicate predicateWithFormat:@"vacancyId == %@", newVacancy.vacancyId];
            NSArray *filteredArray = [_vacancies filteredArrayUsingPredicate:vacancyIdPredicate];
            if (filteredArray.count) {
                continue;
            }
            newVacancy.vacancyName = itemDict[@"name"];
            newVacancy.salary = [[SalaryStringBuilder sharedInstance] getStringFromSalaryDictionary:NULL_TO_NIL(itemDict[@"salary"])];
            NSDictionary *employerDict = itemDict[@"employer"];
            newVacancy.employerName = employerDict[@"name"];
            NSDictionary *logoURLs = NULL_TO_NIL(employerDict[@"logo_urls"]);
            if (logoURLs && logoURLs[@"original"])
                newVacancy.employerLogoImageURL = logoURLs[@"original"];
            [_vacancies addObject:newVacancy];
        }
        [_vacanciesTableView reloadData];
        _isLoading = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Если вакансий больше нет - приходит 400 (bad request)
        [self removeSpinnerFromFooter];
        _currentSet--;
        _isLoading = NO;
    }];
    
    [operation start];
}

-(void)loadDictionariesForSalaryDisplay {
    [[SalaryStringBuilder sharedInstance] loadCurrenciesDictionaryWithCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_vacanciesTableView registerNib:[UINib nibWithNibName:@"VacanciesTableViewCell" bundle:nil]
                  forCellReuseIdentifier:@"VacanciesTableViewCell"];
        _vacanciesTableView.dataSource = self;
        _vacanciesTableView.delegate = self;
        [_vacanciesTableView reloadData];
        _vacanciesTableView.hidden = NO;
    }
                                                                           errorBlock:^{
                                                                               [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                                                                                                   message:@"Не удалось загрузить словари для отображения з/п"
                                                                                                                                  delegate:nil
                                                                                                                         cancelButtonTitle:@"Закрыть"
                                                                                                                         otherButtonTitles:nil];
                                                                               [alertView show];
                                                                           }];
}

-(void)addSpinnerToFooter {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, 4, 44);
    _vacanciesTableView.tableFooterView = spinner;
}

-(void)removeSpinnerFromFooter {
    _vacanciesTableView.tableFooterView = nil;
}

#pragma mark - VacanciesTableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _vacancies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VacanciesTableViewCell *cell = [_vacanciesTableView dequeueReusableCellWithIdentifier:@"VacanciesTableViewCell"];
    
    Vacancy *vacancy = _vacancies[indexPath.row];
    cell.companyNameLabel.text = vacancy.employerName;
    cell.salaryLabel.text = vacancy.salary;
    cell.vacancyNameLabel.text = vacancy.vacancyName;
    cell.companyLogoImageView.imageURL = vacancy.employerLogoImageURL;
    
    return cell;
}

#pragma mark - VacanciesTableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kVacanciesTableViewRowHeight;
}

#pragma mark - UIScrollView delegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height && !_isLoading && [AFNetworkReachabilityManager sharedManager].isReachable) {
        _isLoading = YES;
        _currentSet++;
        [self loadNextVacanciesSet];
    }
}

@end
