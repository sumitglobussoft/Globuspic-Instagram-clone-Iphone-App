//
//  PAPUserPhotoViewController.m
//  Anypic
//
//  Created by Sumit Ghosh on 04/10/14.
//
//

#import "PAPUserPhotoViewController.h"
#import "ImageViewCustomCell.h"
#import "VideoViewController.h"
#import "PAPphotoViewController.h"

@interface PAPUserPhotoViewController ()

@property (nonatomic, strong) PAPphotoViewController *fullPhoto;
@property (nonatomic, strong) VideoViewController *videoVC;
@end

@implementation PAPUserPhotoViewController

@synthesize  user1;
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
    
     self.fullPhoto=[[PAPphotoViewController alloc] init];
    [self getAllUserPhotos];
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    navController=[[UINavigationController alloc]init];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    //    collectioView.backgroundColor=[UIColor redColor];
    collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    [collectionView registerClass:[ImageViewCustomCell class] forCellWithReuseIdentifier:@"cell"];
    //    [collectioView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [self.view addSubview:collectionView];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [collectionView setCollectionViewLayout:flowLayout];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    [self.view addSubview:collectionView];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionview cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier=@"cell";
    
    
    ImageViewCustomCell * cell=(ImageViewCustomCell *)[collectionview dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.imageView.image=[images objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject *object = [wholeObj objectAtIndex:indexPath.row];
    NSString *type = object[@"Type"];
    
    if ([type isEqualToString:@"image"]) {
        if (!self.fullPhoto) {
            
            self.fullPhoto=[[PAPphotoViewController alloc] init];
        }
       
        self.fullPhoto.imageset=[images objectAtIndex:indexPath.row];
       // [self.fullPhoto displaySelctedImage:[images objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:self.fullPhoto animated:YES];
    }
    else if ([type isEqualToString:@"Video"]){
        
        NSLog(@"Video Selected");
        PFFile *videoFile = object[@"image"];
        NSURL *url = [NSURL URLWithString:videoFile.url];
        
        if (!self.videoVC) {
            self.videoVC = [[VideoViewController alloc] init];
        }
        [self.videoVC playVideoWithUrl:url];
        
        [self.navigationController pushViewController:self.videoVC animated:YES];
    }
    
    
}

-(void)getAllUserPhotos{
    
   
    PFQuery * query=[PFQuery queryWithClassName:kPAPPhotoClassKey];
    [query whereKey:kPAPPhotoUserKey equalTo:user1];
  
    
    images=[[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *ary = [query findObjects];
       
        wholeObj = [[NSMutableArray alloc] init];
        videoObj= [[NSMutableArray alloc] init];

        //  NSLog(@"ary = %@",ary);
        for (int i = 0; i < ary.count; i++) {
            
            PFObject *obj = [ary objectAtIndex:i];
            
            
            for (PFObject * participant in ary) {
                if ([participant[@"Type"] isEqual:@"Video"]) [videoObj addObject:participant];
                // [objectIds addObject:participant.objectId];
            }
            
            
            PFFile *userImageFile = obj[@"thumbnail"];
            
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    //  NSLog(@"image is %@",image);
                    if(image)
                    {
                        [images addObject:image];
                        [wholeObj addObject:obj];
                        //NSLog(@"image is %@",image);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [collectionView reloadData];
                        });
                    }
                    //use this image array to set in the imageview .
                    
                    
                }
            }];
            
        }// ENd First For loop
        
    });

    
    /*for(int i=0;i<arr.count;i++)
    {
        PFObject * obj=[arr objectAtIndex:i];
        
        PFFile *userImageFile = obj[@"thumbnail"];
        
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                
                //  NSLog(@"image is %@",image);
                if(image)
                {
                    [images addObject:image];
                    //NSLog(@"image is %@",image);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [collectionView reloadData];
                    });
                }
                //use this image array to set in the imageview .
                
                
            }
        }];

    }*/
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
