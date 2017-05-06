//
//  ViewController.m
//  NodeAdsTestWork
//
//  Created by Oleh on 5/4/17.
//  Copyright © 2017 Oleh. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewCell.h"
#import "Person.h"
#import "CoreService.h"
#import "DeclarationViewController.h"
#import "UIViewController+Helper.h"

static NSString *const DeclarationViewControllerSegueKey = @"declarationSegue";
static NSString *const TableViewCellKey = @"Cell";
static CGFloat const SearchViewNormalHeight = 70.0;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, MainTableViewCellDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *personList;
@property (strong, nonatomic) Person *currentPerson;
@property (strong, nonatomic) NSString *searchString;
@property (assign, nonatomic) NSUInteger currentPageNumber;
@property (assign, nonatomic) NSUInteger totalNumberOfElements;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *numberOfResultsLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mainActivityIndicator;

- (IBAction)segmentedControlAction:(id)sender;
- (IBAction)searchButton:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.personList = [NSMutableArray new];
    
    self.segmentedControl.selectedSegmentIndex = 1;
    [self configurateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:DeclarationViewControllerSegueKey]) {
        DeclarationViewController *declarationController = [segue destinationViewController];
        declarationController.url = self.currentPerson.linkPDF;
        declarationController.navigationTitle = [NSString stringWithFormat:@"%@ %@", self.currentPerson.lastName, self.currentPerson.firstName];
    }
}

#pragma mark - ui methods

- (IBAction)segmentedControlAction:(id)sender {
    [self configurateView];
    [self.mainTableView reloadData];
}

- (IBAction)searchButton:(id)sender {
    [self performSearch];
}

#pragma mark - private methods

- (void)performSearch {
    [self.view endEditing:YES];
    self.searchString = [self.searchTextField.text stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([self.searchString length] == 0) {
        NSError *error = [NSError errorWithDomain:@"Помилка" code:0 userInfo:@{NSLocalizedDescriptionKey : @"Для пошуку необхідно ввести частину імені або прізвища громадянина"}];
        [self showAlertForError:error];
        return;
    }
    [self performDeclarationSearch];
}

- (void)configurateView {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        self.searchViewHeight.constant = 0;
    } else {
        self.searchViewHeight.constant = SearchViewNormalHeight;
    }
}

- (void)performDeclarationSearch {
    [self.personList removeAllObjects];
    [self.mainTableView reloadData];
    self.currentPageNumber = 1;
    self.totalNumberOfElements = 0;
    self.numberOfResultsLabel.text = @"";
    [self downloadNextPage];
}

- (void)downloadNextPage {
    [self.mainActivityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;
    
    __weak typeof(self) weakSelf = self;
    
    [[CoreService sharedInstance] userListForIdentifier:self.searchString withPageNumber:self.currentPageNumber completion:^(NSArray *userList, NSUInteger totalCount, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf showAlertForError:error];
            } else {
                weakSelf.totalNumberOfElements = totalCount;
                [weakSelf.personList addObjectsFromArray:userList];
                self.numberOfResultsLabel.text = [NSString stringWithFormat:@"Відображено %li з %li елементів", [weakSelf.personList count], totalCount];
                [weakSelf.mainTableView reloadData];
            }
            weakSelf.view.userInteractionEnabled = YES;
            [weakSelf.mainActivityIndicator stopAnimating];
        });
    }];
}

- (NSArray *)selectedElementsArray {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        Person *person = evaluatedObject;
        return person.selected == YES;
    }];
    return [self.personList filteredArrayUsingPredicate:predicate];
}

- (void)configureCell:(MainTableViewCell *)cell withPerson:(Person *)person {
    cell.selectedCell = person.selected;
    cell.mainLabel.text = [NSString stringWithFormat:@"%@ %@", person.lastName, person.firstName];
    cell.detailLabel1.text = person.placeOfWork;
    cell.declarationButton.enabled = person.linkPDF ? YES : NO;
    if (cell.cellType == MainTableViewCellTypeSelected) {
        cell.detailLabel2.text = person.comment;
    } else if (cell.cellType == MainTableViewCellTypeAll) {
        cell.detailLabel2.text = person.position;
    }
}

- (void)showAlertForComment:(NSString *)comment {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Введіть коментар" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Коментар";
        textField.text = comment;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *comment = alertController.textFields.firstObject;
        if (comment) {
            self.currentPerson.comment = comment.text;
            [self.mainTableView reloadData];
        }
    }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)defineCurrentPersonFromIndexPath:(NSIndexPath *)indexPath {
    self.currentPerson = nil;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        NSArray *filteredArray = [self selectedElementsArray];
        self.currentPerson = filteredArray[indexPath.row];
    } else {
        self.currentPerson = self.personList[indexPath.row];
    }
}

#pragma mark - table view delegate protocol methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.personList count] < self.totalNumberOfElements && indexPath.row == ([self.personList count] - 5)) {
        self.currentPageNumber += 1;
        [self downloadNextPage];
    }
}

#pragma mark - table view data source protocol methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return [[self selectedElementsArray] count];
    }
    return [self.personList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellKey forIndexPath:indexPath];
    cell.delegate = self;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        cell.cellType = MainTableViewCellTypeSelected;
        NSArray *filteredArray = [self selectedElementsArray];
        Person *person = filteredArray[indexPath.row];
        [self configureCell:cell withPerson:person];
    } else {
        cell.cellType = MainTableViewCellTypeAll;
        Person *person = self.personList[indexPath.row];
        [self configureCell:cell withPerson:person];
    }
    
    return cell;
}

#pragma mark - <UITextFieldDelegate> methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self performSearch];
    return NO;
}

#pragma mark - main table view cell delegate

- (void)editCommentButtonPressed:(MainTableViewCell *)cell {
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    if (indexPath) {
        [self defineCurrentPersonFromIndexPath:indexPath];
        if (self.currentPerson) {
            [self showAlertForComment:self.currentPerson.comment];
        }
    }
}

- (void)declarationButtonPressed:(MainTableViewCell *)cell {
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    if (indexPath) {
        [self defineCurrentPersonFromIndexPath:indexPath];
        if (self.currentPerson) {
            [self performSegueWithIdentifier:DeclarationViewControllerSegueKey sender:self];
        }
    }
}

- (void)selectedButtonPressed:(MainTableViewCell *)cell {
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    if (indexPath) {
        [self defineCurrentPersonFromIndexPath:indexPath];
        if (self.currentPerson) {
            cell.selectedCell = !cell.selectedCell;
            self.currentPerson.selected = !self.currentPerson.selected;
            if (!self.currentPerson.selected) {
                self.currentPerson.comment = @"";
            }
            if (self.segmentedControl.selectedSegmentIndex == 0) {
                [self.mainTableView reloadData];
            } else if (self.currentPerson.selected) {
                [self showAlertForComment:nil];
            }
        }
    }
}

@end
