//
//  PAPMsgViewController.m
//  Anypic
//
//  Created by Sumit Ghosh on 04/09/14.
//
//

#import "PAPMsgViewController.h"

@interface PAPMsgViewController ()

@property (nonatomic,strong)NSArray * searchResults;
@property (nonatomic,strong)NSArray * recipes;
@end

@implementation PAPMsgViewController

@synthesize searchResults,recipes;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    recipes=[[NSArray alloc]init];
    [self queryForTable];
    //recipes=[[NSArray alloc]initWithObjects:@"Roti",@"Dhal", nil];
    
    //    recipes=[[NSUserDefaults standardUserDefaults]objectForKey:@"anyPicFriends"];
    
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction:)];
    
    
   // UITableView * tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 380)];
   // tableView.delegate=self;
   // tableView.dataSource=self;
   // [self.view addSubview:tableView];
    
//    UITableView* tableView1=[[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-100) style:UITableViewStylePlain];
//    tableView1.delegate=self;
//    tableView1.dataSource=self;
//    tableView1.scrollEnabled=YES;
//    [self.view addSubview:tableView1];

    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 100, 320, 44)];
    //[self.view addSubview:searchBar];
   self.tableView.tableHeaderView=searchBar;
    searchBar.delegate=self;
    
    UISearchDisplayController *searchBarDC=[[UISearchDisplayController alloc]initWithSearchBar:searchBar contentsController:self];
    searchBarDC.delegate=self;
    
    
}

- (PFQuery *)queryForTable {
    // Use cached facebook friend ids
    NSArray *facebookFriends = [[PAPCache sharedCache] facebookFriends];
    
    // Query for all friends you have on facebook and who are using the app
    NSLog(@"facebook friend %lu",(unsigned long)facebookFriends.count);
    PFQuery *friendsQuery = [PFUser query];
    [friendsQuery whereKey:kPAPUserFacebookIDKey containedIn:facebookFriends];
    
    // Query for all Parse employees
    NSMutableArray *parseEmployees = [[NSMutableArray alloc] initWithArray:kPAPParseEmployeeAccounts];
    [parseEmployees removeObject:[[PFUser currentUser] objectForKey:kPAPUserFacebookIDKey]];
    PFQuery *parseEmployeeQuery = [PFUser query];
    [parseEmployeeQuery whereKey:kPAPUserFacebookIDKey containedIn:parseEmployees];
    
    // Combine the two queries with an OR
    PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:friendsQuery, parseEmployeeQuery, nil]];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    
//        if (self.objects.count == 0) {
//            query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//        }
    
    [query orderByAscending:kPAPUserDisplayNameKey];
    recipes=[query findObjects];
    NSLog(@"num of friends %ld",(long)recipes.count);
    
    return query;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return recipes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //    if (tableView == self.searchDisplayController.searchResultsTableView) {
    //        cell.textLabel.text = [self.recipes objectAtIndex:indexPath.row];
    //    } else {
    //        cell.textLabel.text = [self.recipes objectAtIndex:indexPath.row];
    //    }
    
   // cell.textLabel.text=[recipes objectAtIndex:indexPath.row];
    cell.textLabel.text=[object objectForKey:kPAPUserDisplayNameKey];
    
    
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];
    
    searchResults = [recipes filteredArrayUsingPredicate:resultPredicate];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return YES;
}


@end
