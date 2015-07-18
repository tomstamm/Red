//
//  RedAppDelegate.m
//  Red
//
//  Created by Tom Stamm on 2/18/11.
//  Copyright 2011 Tom Stamm. All rights reserved.
//

#import "RedAppDelegate.h"

CGGammaValue	gOriginalRedTable[ 256 ];
CGGammaValue	gOriginalGreenTable[ 256 ];
CGGammaValue	gOriginalBlueTable[ 256 ];
int				gRedRamp	= 1;
float			gMax		= 1.0;


@implementation RedAppDelegate

@synthesize window;

- (void) setGamma {
    CGDisplayErr cgErr;
    CGGammaValue redTable[ 256 ];
    CGGammaValue greenTable[ 256 ];
    CGGammaValue blueTable[ 256 ];
	
	if( gMax == 1.0 ) {
		cgErr = CGSetDisplayTransferByTable( 0, 256, gOriginalRedTable, gOriginalGreenTable, gOriginalBlueTable);
	} else {
		for (int i = 0; i < 256 ; i++)
		{
			if( i == 0 ) {
				redTable[ i ] = 0;
				greenTable[ i ] = 0;
				blueTable[ i ] = 0;
			} else {
				if( gRedRamp ) {
					redTable[ i ]	= (float)( i*( 1.0/256.0 ));
					greenTable[ i ]	= (float)( i*( gMax/256.0 ));
				} else {
					redTable[ i ]	= (float)( i*( gMax/256.0 ));
					greenTable[ i ]	= (float)( i*( 1.0/256.0 ));
				}
				blueTable[ i ]	= (float)( i*(gMax/256.0 ));
			}
			
		}
		
		cgErr = CGSetDisplayTransferByTable( 0, 256, redTable, greenTable, blueTable);
	}
}

- (IBAction) colorChanged:(id)sender {
    NSButtonCell *selCell = [sender selectedCell];
	gRedRamp = [selCell tag];
	NSString*	title = [selCell title ];
	[ self setGamma ];
	[ self.window setTitle:title ];
}


- (IBAction) sliderChanged:(id)sender {	
	gMax = 1.0 - ( [sender floatValue] / 100.0 );
	[self setGamma];
}


- (IBAction) terminate:(id)sender {
    CGDisplayErr cgErr;
	
    //  Restore original gamma settings (slowly)
	while( gMax < 1.0 ) { //unRamp
		gMax += ( 1.0/256.0 );
		if( gMax > 1.0 ) gMax = 1.0;
		[ self setGamma ];
		
//		for(int i=0; i<2000000; i++){int j=i;} // Slowly
        usleep(5000);
	}
	
	cgErr = CGSetDisplayTransferByTable( 0, 256, gOriginalRedTable, gOriginalGreenTable, gOriginalBlueTable);
	
	[ NSApp terminate:sender ];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    uint32_t sampleCount;
    CGDisplayErr cgErr;
    
    //  Grab original gamma settings
    cgErr = CGGetDisplayTransferByTable( 0, 256, gOriginalRedTable, gOriginalGreenTable, gOriginalBlueTable, &sampleCount);
	
}

- (void) dealloc {
	[ super dealloc ];
}

@end
