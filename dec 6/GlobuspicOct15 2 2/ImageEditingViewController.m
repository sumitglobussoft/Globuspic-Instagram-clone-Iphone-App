//
//  ImageEditingViewController.m
//  Anypic
//
//  Created by Globussoft 1 on 9/11/14.
//
//

#import "ImageEditingViewController.h"
#import "ImageViewCustomCell.h"
#import "PAPEditPhotoViewController.h"
#import "PAPMessageViewController.h"


@interface ImageEditingViewController ()
{
    CIContext *context;
    NSInteger filterValue,editorValue;
    UIImageOrientation orientation;
    NSMutableArray *imageArray;
    BOOL select,lux,rotat,normal;
    int sliderVal;
    UIImage *copyImage,*modifiedImg,*normalImg;
    UIButton *back,*next,* sel,* cancle,*bright,*setting,*sharpnes;
    UIBarButtonItem *cancelbtn,*rightBarBtn,*nextButton1,*rightBarBtn2,*rightBarBtn3,*rightBarBtn4,*savebtn;
}
@end

@implementation ImageEditingViewController
@synthesize image1,btnLevels,slide,navigationController;
@synthesize newimage;
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
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callParentViewController) name:@"callParent" object:nil];
    
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"SelectedRow"];
    [[NSUserDefaults standardUserDefaults]synchronize ] ;
    
    modifiedImg=self.image1;

       sharpnes=[UIButton buttonWithType:UIButtonTypeCustom];
       sharpnes.frame=CGRectMake(80,0,50,50);
   [sharpnes setImage:[UIImage imageNamed:@"sharpnesNormal.png"] forState:UIControlStateNormal];
      [sharpnes addTarget:self action:@selector(sharpButton:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.headerView addSubview:sharpnes];

    
    setting=[UIButton buttonWithType:UIButtonTypeCustom];
        setting.frame=CGRectMake(210,0,50,50);
    [setting setImage:[UIImage imageNamed:@"settingNormal"] forState:UIControlStateNormal];
    [setting addTarget:self action:@selector(setttingButton:) forControlEvents:UIControlEventTouchUpInside];
       //     [self.headerView addSubview:setting];

    
    
   bright=[UIButton buttonWithType:UIButtonTypeCustom];
    bright.frame=CGRectMake(140,0,50,50);
    [bright setImage:[UIImage imageNamed:@"brightNormal.png"] forState:UIControlStateNormal];
    [bright addTarget:self action:@selector(brightButton:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.headerView addSubview:bright];
//
    
    
    back=[UIButton buttonWithType:UIButtonTypeCustom];
          back.frame=CGRectMake(10,0,50,50);
        [back setTitle:@"Back" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.headerView addSubview:back];
        //    [self.navigationController.view addSubview:back];

    
    next=[UIButton buttonWithType:UIButtonTypeCustom];
           next.frame=CGRectMake(270,0,50,50);
        [next setTitle:@"Next"  forState:UIControlStateNormal];
    [next addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
       //     [self.headerView addSubview:next];
    
    sel=[UIButton buttonWithType:UIButtonTypeCustom];
    sel.frame=CGRectMake(270,0,50,50);
    [sel setTitle:@"Save"  forState:UIControlStateNormal];
    [sel addTarget:self action:@selector(saveButton) forControlEvents:UIControlEventTouchUpInside];
   // [self.headerView addSubview:sel];
    
    cancle=[UIButton buttonWithType:UIButtonTypeCustom];
    cancle.frame=CGRectMake(10,0,65,50);
    [cancle setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
   // [self.headerView addSubview:cancle];
    
    sel.hidden=YES;
    cancle.hidden=YES;

    
    
   rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:bright];
    
      nextButton1 =[[UIBarButtonItem alloc] initWithCustomView:sharpnes];
    
  rightBarBtn2 = [[UIBarButtonItem alloc] initWithCustomView:back];

    rightBarBtn3 = [[UIBarButtonItem alloc] initWithCustomView:setting];
    
     rightBarBtn4 = [[UIBarButtonItem alloc] initWithCustomView:next];
    
   savebtn = [[UIBarButtonItem alloc] initWithCustomView:sel];
    cancelbtn = [[UIBarButtonItem alloc] initWithCustomView:cancle];
    
    self.navigationItem.leftBarButtonItems =@[rightBarBtn2,nextButton1,rightBarBtn,rightBarBtn3,rightBarBtn4];


    if(!view1)
    {
        view1=[[UIView alloc]initWithFrame:CGRectMake(30.0f, 120.0f, 260.0f, 200.0f)];
        [self.view addSubview:view1];
    }
    
    
   
    context = [CIContext contextWithOptions:nil];
    orientation = self.image1.imageOrientation;
    photoImageView=[[UIImageView alloc]init];
    if([UIScreen mainScreen].bounds.size.height>500)
    {
        photoImageView.frame= CGRectMake(0.0f, 0.0f, 260.0f, 250.0f);
    }
    else{
         photoImageView.frame= CGRectMake(0.0f, 0.0f, 260.0f, 200.0f);
    }
    [photoImageView setImage:self.image1];
    [photoImageView setContentMode:UIViewContentModeScaleAspectFit];
    [view1 addSubview:photoImageView];
    
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    self.view.backgroundColor=[UIColor blackColor];
   // self.view.backgroundColor=[UIColor blackColor];
     self.navigationController=[[UINavigationController alloc]init];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 100)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    CGSize s =[UIScreen mainScreen].bounds.size;
    if([UIScreen mainScreen].bounds.size.height>500)
    {
    filtercollectioView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 440, s.width, 140) collectionViewLayout:flowLayout];
    }
    else{
        filtercollectioView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 360, s.width, 120) collectionViewLayout:flowLayout];
    }
    
    [filtercollectioView setDataSource:self];
    [filtercollectioView setDelegate:self];
    [filtercollectioView registerClass:[ImageViewCustomCell class] forCellWithReuseIdentifier:@"cell"];
//  [filtercollectioView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [filtercollectioView setBackgroundColor:[UIColor colorWithRed:9/255.0 green:30/255.0 blue:59/255.0 alpha:1]];
    [filtercollectioView setCollectionViewLayout:flowLayout];
    [self.view addSubview:filtercollectioView];

    self.mySlider = [[UISlider alloc] initWithFrame:CGRectMake(65, 390, 200, 30)];
   // self.mySlider.minimumValue = 0.0f;
   // self.mySlider.maximumValue = 1.0f;
    self.mySlider.hidden = YES;
   [self.mySlider setContinuous:false];
   [self.mySlider addTarget:self
                      action:@selector(getSliderValue:)
            forControlEvents:UIControlEventValueChanged];
   [self.view addSubview:self.mySlider];
    
    imageArray=[[NSMutableArray alloc] init];
    
       for (int i=1; i<=6; i++) {
        
           [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"bloom%d.png",i]]];
    }

    // Do any additional setup after loading the view.
}


-(void)setttingButton:(UIBarButtonItem *)barButton{
    filtercollectioView.hidden=NO;
    editorCollectionView.hidden=YES;
    self.mySlider.hidden=YES;
    [bright setEnabled:NO];
    [sharpnes setEnabled:NO];
    [setting setEnabled:NO];
}

-(void)backButton:(UIBarButtonItem *)barButton{
    filtercollectioView.hidden=YES;
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)brightButton:(UIBarButtonItem *)barButton{
    filtercollectioView.hidden=YES;
    editorCollectionView.hidden=YES;
    lux=YES;
    back.hidden=YES;
    next.hidden=YES;
    
    [bright setEnabled:NO];
    [sharpnes setEnabled:NO];
    [setting setEnabled:NO];
    sel.hidden=NO;
    cancle.hidden=NO;
    self.navigationItem.leftBarButtonItems =@[cancelbtn,nextButton1,rightBarBtn,rightBarBtn3,savebtn];
    
    self.mySlider.minimumValue=0.0f;
    self.mySlider.maximumValue=1.0f;
    self.mySlider.hidden=NO;
    self.mySlider.value=0.5f;
}
-(void)nextButton:(UIBarButtonItem *)barButton{
    
    PAPEditPhotoViewController *viewController = [[PAPEditPhotoViewController alloc] initWithImage:modifiedImg];
     viewController.delegate = self ;
    
    [self.navigationController pushViewController:viewController animated:NO];
    [self presentViewController:self.navigationController animated:YES completion:nil];
}
-(void)sharpButton:(UIBarButtonItem *)barButton{
    [bright setEnabled:NO];
    [sharpnes setEnabled:NO];
    [setting setEnabled:NO];
    filtercollectioView.hidden=YES;
     self.mySlider.hidden=YES;
    self.editorImagesArray=[[NSMutableArray alloc]init];
    
        for (int i=1; i<=8; i++) {
        [self.editorImagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"editorImage%d.png",i ]]];

    }
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(80, 80)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
        if([UIScreen mainScreen].bounds.size.height>500)
        {
            editorCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(-10, 433, self.view.frame.size.width+30, 160) collectionViewLayout:flowLayout];
        }
        else{
            editorCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(-10, 365, self.view.frame.size.width+30, 120) collectionViewLayout:flowLayout];
        }
    [editorCollectionView setDataSource:self];
    [editorCollectionView setDelegate:self];
    [editorCollectionView registerClass:[ImageViewCustomCell class] forCellWithReuseIdentifier:@"cell"];
    [editorCollectionView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
//   [editorCollectionView setBackgroundColor:[UIColor colorWithRed:9/255.0 green:30/255.0 blue:59/255.0 alpha:1]];
    [editorCollectionView setCollectionViewLayout:flowLayout];
    [self.view addSubview:editorCollectionView];
    //}
    editorCollectionView.hidden=NO;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView==filtercollectioView) {
          return imageArray.count;
    }
    else{
        return self.editorImagesArray.count;
    }
    
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier=@"cell";
    ImageViewCustomCell * cell=(ImageViewCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (collectionView==filtercollectioView) {
        cell.imageView.image=[imageArray objectAtIndex:indexPath.row];
    }
    else{
       cell.imageView.image=[self.editorImagesArray objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    back.hidden=YES;
    next.hidden=YES;
    
    sel.hidden=NO;
    cancle.hidden=NO;
    bright.enabled=NO;
     sharpnes.enabled=NO;
    [setting setEnabled:NO];
    
    
     self.navigationItem.leftBarButtonItems =@[cancelbtn,nextButton1,rightBarBtn,rightBarBtn3,savebtn];
    
    if (collectionView==filtercollectioView) {
        select=YES;
        rotateView.hidden=YES;
        filterValue=indexPath.row;
        photoImageView.hidden=NO;
        photoImageView.image=modifiedImg;
        filtercollectioView.hidden=YES;
        CIFilter *sepia;
     CIImage *inputImage = [[CIImage alloc] initWithImage:modifiedImg];
        if(filterValue==2)
        {
            
            
            self.mySlider.maximumValue=3.0f;
            self.mySlider.minimumValue=0.0f;
            self.mySlider.hidden=NO;
            self.mySlider.value=1.5f;
        }
        if(filterValue==1)
        {
            self.mySlider.maximumValue=0.8f;
            self.mySlider.minimumValue=0.0f;
            self.mySlider.value=0.4f;
            self.mySlider.hidden=NO;
        }
        
        if (filterValue==0) {
            normal=YES;
            cancle.hidden=YES;
//            filtercollectioView.hidden=NO;
            if(rotat==YES)
            {
            UIImage * img=[self rotateImgRvrs:sliderVal];
                              photoImageView.image=self.image1;
                normalImg=self.image1;
                //copyImage=self.image1;
                rotat=NO;
                normal=YES;
            }
            else{
 
                normalImg=self.image1;
                //copyImage=self.image1;
            photoImageView.image=self.image1;
            }
        }
        if(filterValue==3)
        {
            self.mySlider.hidden=NO;
            self.mySlider.maximumValue=1.0f;
            self.mySlider.minimumValue=0.0f;
            self.mySlider.value=0.5f;
        }
        if(filterValue==4)
        {
            self.mySlider.hidden=YES;
            //filtercollectioView.hidden=NO;
            //self.mySlider.maximumValue=3.0f;
            //sepia=[CIFilter filterWithName:@"CIVignette" keysAndValues:kCIInputImageKey,img,@"inputRadius",[NSNumber numberWithFloat:100],@"inputIntensity",[NSNumber numberWithFloat:50], nil];
            sepia=[CIFilter filterWithName:@"CIVignette"];
            [sepia setValue:inputImage forKey:kCIInputImageKey];
            [sepia setValue:@(150.0) forKey:@"inputRadius"];
            [sepia setValue:@(3.0) forKey:@"inputIntensity"];
            CGImageRef cgimg = [context createCGImage:sepia.outputImage
                                             fromRect:[sepia.outputImage extent]];
            newimage = [UIImage imageWithCGImage:cgimg scale:1.0 orientation:orientation];
            photoImageView.image=newimage;
            //image1=newimage;
            copyImage=modifiedImg;
            modifiedImg=newimage;
        }
        
        if (filterValue==5) {
            self.mySlider.hidden=YES;
            //filtercollectioView.hidden=NO;
            sepia = [CIFilter filterWithName:@"CIColorControls"];
            [sepia setValue:inputImage forKey:kCIInputImageKey];
            [sepia setValue:@(0.0) forKey:@"inputBrightness"];
            [sepia setValue:@(0.0) forKey:@"inputSaturation"];
            [sepia setValue:@(1.0) forKey:@"inputContrast"];
            CGImageRef cgimg = [context createCGImage:sepia.outputImage
                                             fromRect:[sepia.outputImage extent]];
            newimage = [UIImage imageWithCGImage:cgimg scale:1.0 orientation:orientation];
            photoImageView.image=newimage;
            //self.image1=newimage;
            //image1=newimage;
            copyImage=modifiedImg;
            modifiedImg=newimage;
        }
    }

    
    else{
        select=NO;
        editorValue=indexPath.row;
        self.mySlider.hidden=YES;
        editorCollectionView.hidden=YES;
        if(editorValue==0)
        {
            
            //Adjust
            self.mySlider.hidden=NO;
            self.mySlider.minimumValue = -10.0f;
            self.mySlider.maximumValue = 10.0f;
            self.mySlider.value=0.0f;
        }
        
        if(editorValue==1)
        {
            //brightness
            
            photoImageView.hidden=NO;
           // photoImageView.image=self.image1;
            self.mySlider.maximumValue=0.5;
            self.mySlider.minimumValue=-0.5f;
            self.mySlider.value=0.0f;
            
            self.mySlider.hidden=NO;
        }
        if(editorValue==2)
        {//Contrast
            
            rotateView.hidden=YES;
           // photoImageView.image=self.image1;
            slide.hidden=YES;
            photoImageView.hidden=NO;
            self.mySlider.maximumValue=3.0;//1.5
            self.mySlider.minimumValue=0.5;//.5
            self.mySlider.hidden=NO;
            self.mySlider.value=2.3f;
            
        }
        if(editorValue==3)
        {//saturation
            
            rotateView.hidden=YES;
           // photoImageView.image=self.image1;
            slide.hidden=YES;
            photoImageView.hidden=NO;
            self.mySlider.maximumValue=2.0;
            self.mySlider.minimumValue=0.0;
            self.mySlider.value=1.0;
            self.mySlider.hidden=NO;
        }
        if(editorValue==4)
        {
            //Shadow
            rotateView.hidden=YES;
            slide.hidden=YES;
            
            photoImageView.hidden=NO;
           // photoImageView.image=self.image1;
            self.mySlider.maximumValue=0.0;
            self.mySlider.minimumValue=-0.020f;
            
            self.mySlider.hidden=NO;
            
        }
        if(editorValue==5)
        {
            //sharp
            
            rotateView.hidden=YES;
            //photoImageView.image=self.image1;
            slide.hidden=YES;
            photoImageView.hidden=NO;
            self.mySlider.maximumValue=1.0;
            self.mySlider.minimumValue=0.0;
            self.mySlider.hidden=NO;
        }
        if(editorValue==6)
        {
            //Warmth
            slide.hidden=YES;
            rotateView.hidden=YES;
           // photoImageView.image=self.image1;
            photoImageView.hidden=NO;
            self.mySlider.maximumValue=1.0;
            self.mySlider.minimumValue=-0.5;
             self.mySlider.value=0.2;
            self.mySlider.hidden=NO;
        }
        
      if(editorValue==7)
        {
            //Vignette
            slide.hidden=YES;
            rotateView.hidden=YES;
           // photoImageView.image=self.image1;
            photoImageView.hidden=NO;
            self.mySlider.maximumValue=3.0;
            self.mySlider.minimumValue=0.0;
            // self.mySlider.value=2.2;
            self.mySlider.hidden=NO;
            
        }
    }
    NSLog(@"index path of row %ld",(long)indexPath.row);

}

-(void)getSliderValue:(UISlider *)slider{
    NSLog(@"slider.value is %f",slider.value);
    
    copyImage=self.image1;
    CIImage *inputImage = [[CIImage alloc] initWithImage:modifiedImg];
    CIImage *outputImage;
    if(lux==NO)
    {
    if(select==YES)
    {
        
        outputImage = [self oldPhoto:inputImage withAmount:slider.value];
    }
    else{
        
        outputImage = [self oldPhoto1:inputImage withAmount:slider.value];
    }
    }
    else{
        outputImage=[self addingLuxEffect:inputImage withAmount:slider.value];
    }
    CGImageRef cgimg = [context createCGImage:outputImage
                                     fromRect:[outputImage extent]];
    newimage = [UIImage imageWithCGImage:cgimg scale:1.0 orientation:orientation];
    photoImageView.image = newimage;
    copyImage=modifiedImg;
//    modifiedImg=newimage;
    
    CGImageRelease(cgimg);
}

-(CIImage *)oldPhoto:(CIImage *)img withAmount:(float)intensity {
    CIFilter *sepia;
    
    switch (filterValue) {
        case 2:
            self.mySlider.hidden=NO;
            
            sepia = [CIFilter filterWithName:@"CIBloom" keysAndValues:kCIInputImageKey,img,@"inputIntensity",[NSNumber numberWithFloat:intensity],@"inputRadius",[NSNumber numberWithFloat:0.6f], nil];
            return sepia.outputImage;
            break;
        case 1:
            self.mySlider.hidden=NO;
            
            sepia = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey,img,
                     @"inputColor",[CIColor colorWithString:@"Red"],
                     @"inputIntensity",[NSNumber numberWithFloat:intensity], nil];
            return sepia.outputImage;
            break;
            
        case 0:break;
        case 3:
            
            sepia = [CIFilter filterWithName:@"CISepiaTone"];
            [sepia setValue:img forKey:kCIInputImageKey];
            [sepia setValue:@(intensity) forKey:@"inputIntensity"];
            return sepia.outputImage;
            break;
            
            //            case 4:      sepia=[CIFilter filterWithName:@"CIVignette" keysAndValues:kCIInputImageKey,img,@"inputRadius",[NSNumber numberWithFloat:100],@"inputIntensity",[NSNumber numberWithFloat:50], nil];
            //
            //
            //                           return sepia.outputImage;
            break;
        case 5: break;
        case 6:
            return sepia.outputImage;
            break;
            
        default: return sepia.outputImage;
            break;
    }
    return sepia.outputImage;
}

-(CIImage *)oldPhoto1:(CIImage *)img withAmount:(float)intensity {
    CIFilter *sepia;
    
    
    switch (editorValue) {
        case 0:
            if(!rotateView)
            {
                
                self.mySlider.hidden=NO;
                newimage=[self rotateImage:self.mySlider ];
                
                
                CIImage *inputImage = [[CIImage alloc] initWithImage:newimage];
                
                return inputImage;
                
            }
            
            else{
                
                rotateView.hidden=NO;
                
                self.mySlider.hidden=NO;
                
                newimage=[self rotateImage:self.mySlider ];
                
                
                CIImage *inputImage = [[CIImage alloc] initWithImage:newimage];
                
                return inputImage;
                
                
            }
            
            
            break;
            
        case 1:
            photoImageView.hidden=NO;
          
           sepia = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey,img,@"inputBrightness",[NSNumber numberWithFloat:intensity], nil];
            
            return sepia.outputImage;
           
            break;
            
        case 2:
            
            sepia=    [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey,img,@"inputContrast",[NSNumber numberWithFloat:intensity], nil];
            return sepia.outputImage;
            break;
        
        case 3:
            sepia=    [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey,img,@"inputSaturation",[NSNumber numberWithFloat:intensity], nil];
            return sepia.outputImage;
            break;
        case 4: photoImageView.hidden=NO;
            
            sepia = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey,img,@"inputBrightness",[NSNumber numberWithFloat:intensity], nil];
            return sepia.outputImage;
            
            break;
        case 5:sepia=[CIFilter filterWithName:@"CISharpenLuminance"];
            [sepia setValue:img forKey:kCIInputImageKey];
            [sepia setValue:@(intensity) forKeyPath:@"inputSharpness"];
            
            return sepia.outputImage;
            break;
        case 6:
            sepia = [CIFilter filterWithName:@"CIExposureAdjust"];
            [sepia setValue:img forKey:kCIInputImageKey];
            [sepia setValue:@(intensity) forKey:@"inputEV"];
            return sepia.outputImage;
            break;
            
            
        case 7:
            
            self.mySlider.hidden=NO;
            
            sepia=[CIFilter filterWithName:@"CIVignette" keysAndValues:kCIInputImageKey,img,@"inputRadius",[NSNumber numberWithFloat:100],@"inputIntensity",[NSNumber numberWithFloat:intensity], nil];
            return sepia.outputImage;
            
            
            break;
            
            
        default: return sepia.outputImage;
            break;
    }
    
    return sepia.outputImage;
    
}

-(CIImage *)addingLuxEffect:(CIImage *)img withAmount:(float)intensity{
    [bright setEnabled:NO];
    [sharpnes setEnabled:NO];
    [setting setEnabled:NO];
    CIFilter *sepia;
    sepia=[CIFilter filterWithName:@"CIVibrance"];
    [sepia setValue:img forKey:kCIInputImageKey];
    [sepia setValue:@(intensity) forKey:@"inputAmount"];
    
    return  sepia.outputImage;
    lux=NO;
    
}

-(UIImage *)rotateImgRvrs:(int)slider
{
    
    CGAffineTransform rotate=CGAffineTransformMakeRotation(((-slider/(slider*2.5)) / 180.0 * M_PI));
    //[photoImageView setTransform:rotate];
    photoImageView.transform=rotate;
    
    //newimage=photoImageView.image;
    
    return modifiedImg;
}

-(UIImage *)rotateImage:(UISlider *)slider
{
    sliderVal=slider.value;
    CGAffineTransform rotate=CGAffineTransformMakeRotation((slider.value / 180.0 * M_PI));
    //[photoImageView setTransform:rotate];
    photoImageView.transform=rotate;
    
    newimage=photoImageView.image;
    
    return self.newimage;
}
-(void) saveButton{
     modifiedImg=newimage;
     cancle.hidden=NO;
   if(lux==NO)
   {
    
    if(editorCollectionView.hidden==YES)
    {
        if(editorValue==0)
        {
            
            UIGraphicsBeginImageContext(view1.bounds.size);
            
            [view1.layer renderInContext:UIGraphicsGetCurrentContext()];
            
            newimage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            rotat=YES;
//            self.image1=self.newimage;
            modifiedImg=newimage;
            copyImage=modifiedImg;
            photoImageView.image=newimage;
            //copyImage=self.newimage;
            editorValue=20;
        }
        else
        {
            //self.image1=copyImage;
//            self.image1=modifiedImg;
            
//            if(filterValue==0)
//            {
//                modifiedImg=self.image1;
//                filterValue=10;
//            }
            if(normal==YES)
            {
                modifiedImg=normalImg;
                normal=NO;
            }
            
                        photoImageView.image=modifiedImg;
        }
        editorCollectionView.hidden=NO;
        filtercollectioView.hidden=YES;
    }
   }
   else{
          }
    if(filtercollectioView.hidden==YES)
    {
        filtercollectioView.hidden=NO;
        editorCollectionView.hidden=YES;
//        self.image1=modifiedImg;
        //if(filterValue==0)
       // {
       //     modifiedImg=self.image1;
       //     filterValue=10;
      //  }
        if(normalImg)
        {
            modifiedImg=normalImg;
            normalImg=nil;
        }
        photoImageView.image=modifiedImg;
        
    }
    [bright setEnabled:YES];
    [sharpnes setEnabled:YES];
    [setting setEnabled:YES];
    next.hidden=NO;
    back.hidden=NO;
    lux=NO;
    sel.hidden=YES;
    cancle.hidden=YES;
     self.navigationItem.leftBarButtonItems =@[rightBarBtn2,nextButton1,rightBarBtn,rightBarBtn3,rightBarBtn4];
    self.mySlider.hidden=YES;
}

-(void)cancelButton:(id)sender{
    lux=NO;
    photoImageView.hidden=NO;
//    image1=modifiedImg;
    photoImageView.image=copyImage;
    modifiedImg=copyImage;
    tiltView.hidden=YES;
    
    next.hidden=NO;
    back.hidden=NO;
    
    sel.hidden=YES;
    cancle.hidden=YES;
     self.navigationItem.leftBarButtonItems =@[rightBarBtn2,nextButton1,rightBarBtn,rightBarBtn3,rightBarBtn4];
    self.mySlider.hidden=YES;
    
    if(editorValue==0)
    {
        CGAffineTransform rotate=CGAffineTransformMakeRotation((0.0/ 180.0 * M_PI));
        //[photoImageView setTransform:rotate];
        photoImageView.transform=rotate;

        
    }
    if(filtercollectioView.hidden==YES)
    {
        filtercollectioView.hidden=NO;
        editorCollectionView.hidden=YES;
    }
    else{
        filtercollectioView.hidden=YES;
        editorCollectionView.hidden=NO;
    }
    [bright setEnabled:YES];
    [sharpnes setEnabled:YES];
    [setting setEnabled:YES];
    
}

- (void)callParentViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//-(void)callParentViewController1{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -gestures

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
