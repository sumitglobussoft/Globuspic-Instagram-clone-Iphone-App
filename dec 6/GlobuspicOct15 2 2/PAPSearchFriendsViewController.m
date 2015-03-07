//
//  PAPSearchFriendsViewController.m
//  Anypic
//
//  Created by Sumit Ghosh on 27/09/14.
//
//

#import "PAPSearchFriendsViewController.h"
#import "PAPAccountViewController.h"
#import "PAPPhotoHeaderView.h"
#import "UIImageView+WebCache.h"

@interface PAPSearchFriendsViewController ()

@end

@implementation PAPSearchFriendsViewController
@synthesize obj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    namesOfUser=[[NSMutableArray alloc]init];
    userId=[[NSMutableArray alloc]init];
    navigationCtrl =[[UINavigationController alloc]init];
    [self getUserInfo];

    
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self createTable];
    
    //searchBox=[[UITextField alloc]initWithFrame:CGRectMake(80.0, 30.0, 150.0, 20)];
    searchBox=[[UITextField alloc]initWithFrame:CGRectMake(0.0, 0.0, 150.0, 20)];
    searchBox.delegate=self;
    searchBox.backgroundColor=[UIColor whiteColor];
    [searchBox  setBorderStyle:UITextBorderStyleRoundedRect];
    [searchBox setFont:[UIFont systemFontOfSize:10]];
    searchBox.placeholder =@" Search Friends";
    
    
    UIButton * btn=[[UIButton alloc]initWithFrame:CGRectMake(0.0, 30.0, 150.0, 20)];
    //[btn setTitle:@"text" forState:UIControlStateNormal];
    [btn addSubview:searchBox];
    
    UIBarButtonItem * rightbtn=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
  //  [self.navigationController.navigationBar addSubview:searchBox];
   self.navigationItem.rightBarButtonItem=rightbtn;
    
    // Do any additional setup after loading the view.
}

-(void)getUserInfo
{
    dict=[[NSMutableDictionary alloc]init];
     objdetail=[[NSMutableArray alloc]init];
    fbidArr=[[NSMutableArray alloc ]init];
    images1=[[NSMutableArray alloc ]init];
    user=[[NSMutableArray alloc]init];
    
    PFQuery * query=[PFQuery queryWithClassName:@"_User"];
    [query orderByAscending:kPAPUserDisplayNameKey];
    user=(NSMutableArray *)[query findObjects];
    
    for (int i=0; i<user.count; i++) {
        NSLog(@"user array is %@",user[i]);
    }
    
    //dispatch_async(dispatch_get_global_queue(0, 0), ^{
    for(int i=0;i<user.count;i++)
    {
        obj=[user objectAtIndex:i];
        NSLog(@"Object -==- %@",obj);
//        NSString *str1 = obj[@"followRequest"];
        
        NSString *str=[obj objectId];
        NSLog(@"object id %@",[obj objectId]);
        if(![str isEqualToString:[[PFUser currentUser]objectId]])
           {
               [namesOfUser addObject:obj[@"displayName"]];
               [fbidArr addObject:obj[kPAPUserFacebookIDKey]];
               [objdetail addObject:obj];
               [userId addObject:str];
                NSLog(@"names of Array %@",namesOfUser);
           }
}
   
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return  YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return  YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString * str=searchBox.text;
    [self filterContentForSearchText:str ];
    [searchBox resignFirstResponder];
    
    return  YES;
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    searchImg=[[NSMutableArray alloc]init];
    srchFbArr=[[NSMutableArray alloc]init];

    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd]%@",searchText];
    searchResults= [NSMutableArray arrayWithArray: [namesOfUser filteredArrayUsingPredicate:resultPredicate]];
  
    NSLog(@"search result count %lu",(unsigned long)searchResults.count);
 
    
    if(searchResults.count!=0)
    {
    //[self createTable];
       /* for (int i=0; i<namesOfUser.count; i++) {
            NSString *srname=[searchResults objectAtIndex:i];
            NSString *name=[namesOfUser objectAtIndex:i];
            if ([srname isEqualToString:name]) {
                [srchFbArr addObject:fbidArr[i]];
            }
        }*/
        
        [table1 reloadData];
        search=YES;
    }
    else{
        NSLog(@"No friends found");
    }
    
}

-(void)createTable{
    table1 =[[UITableView alloc]initWithFrame:CGRectMake(0.0, 5.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    table1.delegate=self;
    table1.dataSource=self;
    [self.view addSubview:table1];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(searchResults.count!=0)
    {
    return  searchResults.count;
    }
    else{
        return namesOfUser.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  30.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier=@"Identifier";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    
    if(searchResults.count!=0)
    {
    cell.textLabel.text=[searchResults objectAtIndex:indexPath.row];
     
    }
    else{
    cell.textLabel.text=[namesOfUser objectAtIndex:indexPath.row];
       
    }
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * fbid;
    PFObject * serchObj;
    int  path;
    
    if (!search) {
       
        fbid=[fbidArr objectAtIndex:indexPath.row];
        obj=[objdetail objectAtIndex:indexPath.row];
        NSLog(@"obj is %@",obj);
        NSLog(@"fbid is %@",fbid);
        NSLog(@"obj details %@",objdetail);
        
        if([fbid isEqualToString:[obj objectForKey:kPAPUserFacebookIDKey]])
        {
            PAPAccountViewController *detailViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
            [detailViewController setUser:[objdetail objectAtIndex:indexPath.row]];
            [self.navigationController pushViewController:detailViewController animated:YES];
            
        }
    }
    else{
        
        search =NO;
        srchDetail=[[NSMutableArray alloc]init];
    NSString * name=searchResults[indexPath.row];
        
    for(int i=0;i<namesOfUser.count;i++)
    {
        if([name isEqualToString:[namesOfUser objectAtIndex:i]])
        {
             fbid=fbidArr[i];
       /* PFQuery * query=[PFQuery queryWithClassName:@"_User"];
            [query whereKey:@"facebookId" equalTo:fbid];
             serchObj=[query getFirstObject];
           
            [srchDetail addObject:obj];
            NSLog(@"Object %@",obj);*/
            path=i;
        
          
        }
        
    }

   obj=[objdetail objectAtIndex:path];
    if([fbid isEqualToString:[obj objectForKey:kPAPUserFacebookIDKey]])
    {
        NSLog(@"Object Detail %@",objdetail);
        PAPAccountViewController *detailViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
        [detailViewController setUser:[objdetail objectAtIndex:path]];
       
        [searchResults removeAllObjects];
        if(searchResults.count==0)
        {
        [table1 reloadData];
            searchBox.text=nil;
            searchBox.placeholder=@" Search Friends";
        }
        [self.navigationController pushViewController:detailViewController animated:YES];
    
    }
    
}
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
