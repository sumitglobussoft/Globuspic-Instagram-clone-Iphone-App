//
//  VideoEditingViewController.m
//  Anypic
//
//  Created by Globussoft 1 on 9/18/14.
//
//

#import "VideoEditingViewController.h"
#import "ImageViewCustomCell.h"
#import "PAPEditVideoViewController.h"

@interface VideoEditingViewController ()
{
    NSMutableArray *thumbTimes;
    NSMutableArray *arrayOfImages;
    NSMutableArray *filterImageArray;
    UIImageView *thumbnailImageView;
    UIImageView *thumbnailImagePicker;
}
@end

@implementation VideoEditingViewController
@synthesize urlstr;
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
    
    filterImageArray=[[NSMutableArray alloc] init];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [self screenshotOfVideo];

    UIButton *filterButton=[UIButton buttonWithType:UIButtonTypeCustom];
    filterButton.frame=CGRectMake(90,0,50,50);
    [filterButton setImage:[UIImage imageNamed:@"brightNormal.png"] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterButton:) forControlEvents:UIControlEventTouchUpInside];
        ////    [self.headerView addSubview:bright];
        //
    
    for (int i=1; i<=6; i++) {
        
        [filterImageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"bloom%d.png",i]]];
    }

    
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(10,0,50,50);
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
        //    [self.navigationController.view addSubview:back];
    
    UIButton *frameButton=[UIButton buttonWithType:UIButtonTypeCustom];
    frameButton.frame=CGRectMake(170,0,100,50);
    [frameButton setTitle:@"setFrame" forState:UIControlStateNormal];
    [frameButton addTarget:self action:@selector(frameButton:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *next=[UIButton buttonWithType:UIButtonTypeCustom];
    next.frame=CGRectMake(290,0,50,50);
    [next setTitle:@"Next"  forState:UIControlStateNormal];
    [next addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
        ////    [self.headerView addSubview:next];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    UIBarButtonItem *nextButton1 =[[UIBarButtonItem alloc] initWithCustomView:next];
    UIBarButtonItem *screenShotSetButton =[[UIBarButtonItem alloc] initWithCustomView:frameButton];
    UIBarButtonItem *rightBarBtn2 = [[UIBarButtonItem alloc] initWithCustomView:back];

    self.navigationItem.rightBarButtonItems=@[nextButton1,screenShotSetButton];
    
    self.navigationItem.leftBarButtonItems=@[rightBarBtn2,rightBarBtn,screenShotSetButton,nextButton1];

    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    filtercollectioView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 340, self.view.frame.size.width, 120) collectionViewLayout:flowLayout];
    [filtercollectioView setDataSource:self];
    [filtercollectioView setDelegate:self];
    [filtercollectioView registerClass:[ImageViewCustomCell class] forCellWithReuseIdentifier:@"cell"];
        //  [filtercollectioView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [filtercollectioView setBackgroundColor:[UIColor colorWithRed:9/255.0 green:30/255.0 blue:59/255.0 alpha:1]];
    [filtercollectioView setCollectionViewLayout:flowLayout];
    [self.view addSubview:filtercollectioView];
        // Do any additional setup after loading the view.
}

-(void)frameButton:(UIBarButtonItem *)barButton{
  
   filtercollectioView.hidden=YES;
//    if (!framecollectioView) {
//       
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        [flowLayout setItemSize:CGSizeMake(100, 100)];
//        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//
//    framecollectioView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 340, self.view.frame.size.width, 120) collectionViewLayout:flowLayout];
//    [framecollectioView setDataSource:self];
//    [framecollectioView setDelegate:self];
//    [framecollectioView registerClass:[ImageViewCustomCell class] forCellWithReuseIdentifier:@"cell"];
//        //  [filtercollectioView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
//    [framecollectioView setBackgroundColor:[UIColor colorWithRed:9/255.0 green:30/255.0 blue:59/255.0 alpha:1]];
//    [framecollectioView setCollectionViewLayout:flowLayout];
//    [self.view addSubview:framecollectioView];
//    }
//    else{
//    
//        framecollectioView.hidden=NO;
//    }
    
    UIView *viewed=[[UIView alloc] initWithFrame:CGRectMake(0, 400, 320, 80)];
    viewed.backgroundColor=[UIColor greenColor];
    [self.view addSubview:viewed];
    
   
    
    for (int i=0; i<5; i++) {
    
        thumbnailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+i*30, 20, 30,30)];
        thumbnailImageView.image=[arrayOfImages objectAtIndex:i];
        thumbnailImageView.tag=i;
        [viewed addSubview:thumbnailImageView];
       
            }
    
        if (!thumbnailImagePicker) {
        thumbnailImagePicker=[[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 50, 50)];
        [viewed addSubview:thumbnailImagePicker];
            UIPanGestureRecognizer *panGst=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRcog:)];
            [thumbnailImagePicker addGestureRecognizer:panGst];

        
    }
   
}


-(void)backButton:(UIBarButtonItem *)barButton{

//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}


-(void)gestureRcog:(UIPanGestureRecognizer *)gesture{
    
    NSLog(@"hello");
    UIImageView *img=(UIImageView *)[gesture view];
    thumbnailImagePicker.image=img.image;
    NSLog(@"gesture x %f",gesture.view.frame.origin.x);
    NSLog(@"gesture y %f",gesture.view.frame.origin.y);
    thumbnailImagePicker.frame=CGRectMake(gesture.view.frame.origin.x, gesture.view.frame.origin.y, 50, 50);
    
}
-(void)nextButton:(UIBarButtonItem *)barButton{
    
    if (! viewController1) {
        viewController1=[[PAPEditVideoViewController  alloc]init];
    }
    viewController1.urlstr=self.urlstr;
    
    [self.navigationController pushViewController:viewController1 animated:NO];
//    [self presentViewController:self.navigationController animated:YES completion:nil];

}

-(void)filterButton:(UIBarButtonItem *)barButton{
    
    filtercollectioView.hidden=NO;
    framecollectioView.hidden=YES;
    
}

-(void )screenshotOfVideo{
    
    AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:self.urlstr options:nil];
   arrayOfImages=[[NSMutableArray alloc] init];

    thumbTimes=[[NSMutableArray alloc]init];
    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
    generate1.appliesPreferredTrackTransform = YES;

    for(int t=0;t < asset1.duration.value;t=t+200) {
        CMTime thumbTime = CMTimeMake(t, asset1.duration.timescale);
        NSLog(@"Time Scale : %d ", asset1.duration.timescale);
        NSValue *v=[NSValue valueWithCMTime:thumbTime];
        [thumbTimes addObject:v];
    }
    //    NSLog(@"thumbTimes array  video %lu",(unsigned long)thumbTimes.count);
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
       [arrayOfImages addObject:[UIImage imageWithCGImage:im]];
        NSLog(@"image count %lu",(unsigned long)arrayOfImages.count);
   };
    [generate1 generateCGImagesAsynchronouslyForTimes:thumbTimes completionHandler:handler];
    [framecollectioView reloadData];
//    
//    NSLog(@"image array count is %lu",(unsigned long)arrayOfImages.count);
    
        //    UIImage *image1  = [UIImage imageNamed:@"play_btn.png"]; //foreground image
        //
        //    CGSize newSize = one.size;
        //    UIGraphicsBeginImageContext( newSize );
        //
        //        // Use existing opacity as is
        //    [one drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        //
        //        // Apply supplied opacity if applicable
        //    [image1 drawInRect:CGRectMake(newSize.width/2-20,newSize.height/2-20,60,60) blendMode:kCGBlendModeNormal alpha:0.8];
        //
        //    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        //     self.thumbnail=newImage;
        //    UIGraphicsEndImageContext();
    
        //    self.thumbnail.contentMode = UIViewContentModeScaleAspectFit;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    if (collectionView==framecollectioView) {
        return arrayOfImages.count;
    }
    else {
        return filterImageArray.count;
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
       NSString * identifier=@"cell";
    ImageViewCustomCell * cell=(ImageViewCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
 
    if (collectionView==framecollectioView) {
   cell.imageView.image=[arrayOfImages objectAtIndex:indexPath.row];
    }
    else{
   cell.imageView.image=[filterImageArray objectAtIndex:indexPath.row];
    }
       return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
