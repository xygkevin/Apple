//
//  ViewController.m
//  SpookCam
//
//  Created by Jack Wu on 2/21/2014.
//
//

#import "ViewController.h"
#import "ImageProcessor.h"
#import "UIImage+OrientationFix.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageProcessorDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@property (strong, nonatomic) UIImagePickerController * imagePickerController;
@property (strong, nonatomic) UIImage * workingImage;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//  [self setupWithImage:[UIImage imageNamed:@"ghost_tiny.png"]];
    
    UIGraphicsBeginImageContext(self.view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    MyColoredPatternPainting(context, CGRectMake(0, 0, 100, 200));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.mainImageView.image = image;
}


#define H_PATTERN_SIZE 16
#define V_PATTERN_SIZE 18


void MyDrawColoredPattern (void *info, CGContextRef myContext)
{
    CGFloat subunit = 5; // the pattern cell itself is 16 by 18
    
    CGRect  myRect1 = {{0,0}, {subunit, subunit}},
    myRect2 = {{subunit, subunit}, {subunit, subunit}},
    myRect3 = {{0,subunit}, {subunit, subunit}},
    myRect4 = {{subunit,0}, {subunit, subunit}};
    
    CGContextSetRGBFillColor (myContext, 0, 0, 1, 0.5);
    CGContextFillRect (myContext, myRect1);
    CGContextSetRGBFillColor (myContext, 1, 0, 0, 0.5);
    CGContextFillRect (myContext, myRect2);
    CGContextSetRGBFillColor (myContext, 0, 1, 0, 0.5);
    CGContextFillRect (myContext, myRect3);
    CGContextSetRGBFillColor (myContext, .5, 0, .5, 0.5);
    CGContextFillRect (myContext, myRect4);
}


void MyColoredPatternPainting (CGContextRef myContext,
                               CGRect rect)
{
    CGPatternRef    pattern;// 1
    CGColorSpaceRef patternSpace;// 2
    CGFloat         alpha = 1,// 3
    width, height;// 4
    static const CGPatternCallbacks callbacks = {0, &MyDrawColoredPattern,NULL}; // 5
    
    CGContextSaveGState (myContext);
    patternSpace = CGColorSpaceCreatePattern (NULL);// 6
    CGContextSetFillColorSpace (myContext, patternSpace);// 7
    CGColorSpaceRelease (patternSpace);// 8
    
    pattern = CGPatternCreate (NULL, // 9
                               CGRectMake (0, 0, H_PATTERN_SIZE, V_PATTERN_SIZE),// 10
                               CGAffineTransformMake (1, 0, 0, 1, 0, 0),// 11
                               H_PATTERN_SIZE, // 12
                               V_PATTERN_SIZE, // 13
                               kCGPatternTilingConstantSpacing,// 14
                               true, // 15
                               &callbacks);// 16
    
    CGContextSetFillPattern (myContext, pattern, &alpha);// 17
    CGPatternRelease (pattern);// 18
    CGContextFillRect (myContext, rect);// 19
    CGContextRestoreGState (myContext);
}



#pragma mark - Custom Accessors

- (UIImagePickerController *)imagePickerController {
  if (!_imagePickerController) { /* Lazy Loading */
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.allowsEditing = NO;
    _imagePickerController.delegate = self;
  }
  return _imagePickerController;
}

#pragma mark - IBActions

- (IBAction)takePhotoFromCamera:(UIBarButtonItem *)sender {
  self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
  [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)takePhotoFromAlbum:(UIBarButtonItem *)sender {
  self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)savePhoto:(UIBarButtonItem *)sender {
  if (!self.workingImage) {
    return;
  }
  UIImageWriteToSavedPhotosAlbum(self.workingImage, nil, nil, nil);
}

#pragma mark - Private

- (void)setupWithImage:(UIImage*)image {
  UIImage * fixedImage = [image imageWithFixedOrientation];
  self.workingImage = fixedImage;
  self.mainImageView.image = fixedImage;
  
  // Commence with processing!
//  [self logPixelsOfImage:fixedImage];
    [[ImageProcessor sharedProcessor] setDelegate:self];
    [[ImageProcessor sharedProcessor] processImage:fixedImage];
}

- (void)logPixelsOfImage:(UIImage*)image {
  // 1. Get pixels of image
  CGImageRef inputCGImage = [image CGImage];
  NSUInteger width = CGImageGetWidth(inputCGImage);
  NSUInteger height = CGImageGetHeight(inputCGImage);
  
  NSUInteger bytesPerPixel = 4;
  NSUInteger bytesPerRow = bytesPerPixel * width;
  NSUInteger bitsPerComponent = 8;
  
  UInt32 * pixels;
  pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(pixels, width, height,
                                               bitsPerComponent, bytesPerRow, colorSpace,
                                               kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
  
  CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
  
  CGColorSpaceRelease(colorSpace);
  CGContextRelease(context);
  
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
  
  // 2. Iterate and log!
  NSLog(@"Brightness of image:");
  UInt32 * currentPixel = pixels;
  for (NSUInteger j = 0; j < height; j++) {
    for (NSUInteger i = 0; i < width; i++) {
      UInt32 color = *currentPixel;
      printf("%3.0f ", (R(color)+G(color)+B(color))/3.0);
      currentPixel++;
    }
    printf("\n");
  }
  
  free(pixels);
  
#undef R
#undef G
#undef B
  
}

#pragma mark - Protocol Conformance

- (void)imageProcessorFinishedProcessingWithImage:(UIImage *)outputImage {
  self.workingImage = outputImage;
  self.mainImageView.image = outputImage;
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  // Dismiss the imagepicker
  [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
  
  [self setupWithImage:info[UIImagePickerControllerOriginalImage]];
}

@end
