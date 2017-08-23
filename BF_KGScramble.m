/*
 *	Copyright 2014, 
 *
 *	All rights reserved.
 *
 *	Redistribution and use in source and binary forms, with or without modification, are 
 *	permitted provided that the following conditions are met:
 *
 *	Redistributions of source code must retain the above copyright notice which includes the
 *	name(s) of the copyright holders. It must also retain this list of conditions and the 
 *	following disclaimer. 
 *
 *	Redistributions in binary form must reproduce the above copyright notice, this list 
 *	of conditions and the following disclaimer in the documentation and/or other materials 
 *	provided with the distribution. 
 *
 *	Neither the name of David Book, or buzztouch.com nor the names of its contributors 
 *	may be used to endorse or promote products derived from this software without specific 
 *	prior written permission.
 *
 *	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 *	IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 *	INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
 *	NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
 *	PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 *	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 *	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
 *	OF SUCH DAMAGE. 
 */


#import "BF_KGScramble.h"
#import "config.h"
#import "BF_KGScramble.h"
#import "GameController.h"
#import "HUDView.h"
#import "BT_downloader.h"


@interface BF_KGScramble()

@property (strong, nonatomic) GameController* controller;

@end

@implementation BF_KGScramble


//setup the view and instantiate the game controller
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [[GameController alloc] init];
    
    //add one layer for all game elements
    UIView* gameLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview: gameLayer];
    
    self.controller.gameView = gameLayer;
    
    //add one layer for all hud and controls
    HUDView* hudView = [HUDView viewWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:hudView];
    
    self.controller.hud = hudView;
    
    __weak BF_KGScramble* weakSelf = self;
    self.controller.onWordSolved = ^(){
    
        [weakSelf loadScreenWithNickname:weakSelf.landingScreenName];
    
        //[weakSelf showLevelMenu];
        
    };
    
    //init the items array
    self.wordList = [[NSMutableArray alloc] init];

    
    //[self getBTVars];
    
}

//show tha game menu on app start
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:(@selector(loadData)) withObject:nil afterDelay:0.1];
    
  
    
}

#pragma mark - getBTVars
-(void)getBTVars{
    
    self.landingScreenName = [BT_strings getJsonPropertyValue:self.screenData.jsonVars nameOfProperty:@"landingScreenNickname" defaultValue:@""];
    
    self.controller.timerValue = [[BT_strings getJsonPropertyValue:self.screenData.jsonVars nameOfProperty:@"timer" defaultValue:@"30"] intValue];
    
    self.controller.pointsPerLetter =  [[BT_strings getJsonPropertyValue:self.screenData.jsonVars nameOfProperty:@"pointsPerLetter" defaultValue:@"10"] intValue];
   
    
    for(int index=0; index < self.wordList.count; index++){
    //get the current question
        BT_item *tmpWordList = [self.wordList objectAtIndex:index];
        
        NSString *tmpCorrectWord = [BT_strings getJsonPropertyValue:tmpWordList.jsonVars nameOfProperty:@"correct_word" defaultValue:@""];
        [self.controller.correctWordList addObject:tmpCorrectWord];
        
        [self.controller.scrambledWordList addObject: [BT_strings getJsonPropertyValue:tmpWordList.jsonVars nameOfProperty:@"scrambled_word" defaultValue:@""]];
        
    }


    [self testBTVars];
    [self fireGame];
    
}

-(void)testBTVars{
    
    [BT_debugger showIt:self message:[NSString stringWithFormat:@"landing screen nickname : %@", self.landingScreenName]];
    
    [BT_debugger showIt:self message:[NSString stringWithFormat:@"timer value : %ld", (long)self.controller.timerValue]];
    
    [BT_debugger showIt:self message:[NSString stringWithFormat:@"points per letter : %ld", (long)self.controller.pointsPerLetter]];
    
    [BT_debugger showIt:self message:@"Correct Word List: "];
    for(NSString *cWord in self.controller.correctWordList){
        [BT_debugger showIt:self message:cWord];
    }
    [BT_debugger showIt:self message:@"Scrambled Word List: "];
    for(NSString *sWord in self.controller.scrambledWordList){
        [BT_debugger showIt:self message:sWord];
    }
    
    
}


#pragma mark - loadData
-(void)loadData {
    // [BT_debugger showIt:self theMessage:@"loadData"];
    
	self.saveAsFileName = [NSString stringWithFormat:@"screenData_%@.txt", [self.screenData itemId]];
	
	//do we have a URL?
	BOOL haveURL = FALSE;
	if([[BT_strings getJsonPropertyValue:self.screenData.jsonVars nameOfProperty:@"dataURL" defaultValue:@""] length] > 10){
		haveURL = TRUE;
	}
	
	//start by filling the list from the configuration file, use these if we can't get anything from a URL
	if([[self.screenData jsonVars] objectForKey:@"childItems"]){
		[BT_debugger showIt:self message:@"Screen has childItems array"];

        NSArray *tmpQuestions = [[self.screenData jsonVars] objectForKey:@"childItems"];
		for(NSDictionary *tmpQuestion in tmpQuestions){
			BT_item *thisPair = [[BT_item alloc] init];
			thisPair.itemId = [tmpQuestion objectForKey:@"itemId"];
			thisPair.itemType = [tmpQuestion objectForKey:@"itemType"];
			thisPair.jsonVars = tmpQuestion;
			[self.wordList addObject:thisPair];
            
            //loop through word list verify child items exist.
            //For testing only.
//            for(int i = 0; i<[self.wordList count]; i++){
//                BT_item *tmpWords = [self.wordList objectAtIndex:i];
//                NSString *tmpCorrectWord = [BT_strings getJsonPropertyValue:tmpWords.jsonVars nameOfProperty:@"correct_word" defaultValue:@"default value correct"];
//                NSString *tmpScrambledWord = [BT_strings getJsonPropertyValue:tmpWords.jsonVars nameOfProperty:@"scrambled_word" defaultValue:@"default value scrambled"];
//                [BT_debugger showIt:self message:tmpCorrectWord];
//                [BT_debugger showIt:self message:tmpScrambledWord];
//            }
            
            }
        
            [self getBTVars];
            

	}else{
		[BT_debugger showIt:self theMessage:@"the quiz screen does not have a childItems[] array"];
	}
	
	//if we have a URL, fetch..
	if([[BT_strings getJsonPropertyValue:self.screenData.jsonVars nameOfProperty:@"dataURL" defaultValue:@""] hasPrefix:@"http"]) {
		//look for a previously cached version of this screens data…
		if([BT_fileManager doesLocalFileExist:[self saveAsFileName]]){
			NSString *staleData = [BT_fileManager readTextFileFromCacheWithEncoding: self.saveAsFileName  encodingFlag:-1];
            [self parseScreenData:staleData];
		}else{
			//[BT_debugger showIt:self theMessage:@"no cached version of the quiz questions found"];
			[self downloadData];
		}
	}else{
        
		//see if we have a file in the Xcode project names the
        //same as the childItemsLocalFileName property in the JSON
        //that contains the childItems data…
        NSString *localFileName = [BT_strings getJsonPropertyValue:self.screenData.jsonVars nameOfProperty:@"dataURL" defaultValue:@"unused.txt"];
        
        if([BT_fileManager doesFileExistInBundle:localFileName]){
            //read the contents of the file included in the Xcode project…
            NSString *childItemsData = [BT_fileManager readTextFileFromBundleWithEncoding:localFileName encodingFlag:-1];
            //pass this data to the parseScreenData method…
            [self parseScreenData:childItemsData];
        }else{
			//show the child items in the config data
            [BT_debugger showIt:self theMessage:@"no dataURL found for this quiz screen"];		}
	}
}// end loadData ----------------------------

//download data
-(void)downloadData {
	
	[BT_debugger showIt:self theMessage:@"Download Data method called" ];
	
	//flag this as the current screen
	
	kindergartensightwordscramble_appDelegate *appDelegate = (kindergartensightwordscramble_appDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.rootApp.currentScreenData = self.screenData;
    
	[self showProgress];
	
	NSString *tmpURL = @"";
	if([[BT_strings getJsonPropertyValue:self.screenData.jsonVars nameOfProperty:@"dataURL" defaultValue:@""] length] > 3){
		//merge url variables
		tmpURL = [BT_strings getJsonPropertyValue:self.screenData.jsonVars nameOfProperty:@"dataURL" defaultValue:@""];
		tmpURL = [tmpURL stringByReplacingOccurrencesOfString:@"[screenId]" withString:[self.screenData itemId]];
		///merge possible variables in URL
		NSString *useURL = [BT_strings mergeBTVariablesInString:tmpURL];
		NSString *escapedUrl = [useURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		//fire downloader to fetch and results
		self.downloader = [[BT_downloader alloc] init];
		[self.downloader setSaveAsFileName:[self saveAsFileName]];
		[self.downloader setSaveAsFileType:@"text"];
		[self.downloader setUrlString:escapedUrl];
		[self.downloader setDelegate:self];
		[self.downloader downloadFile];
	}
    
}// end download data--------------------------

//parse screen data
-(void)parseScreenData:(NSString *)theData{
    
	[BT_debugger showIt:self theMessage:@"parse Screen Data"];
    
	@try {
        
		//create dictionary from the JSON string
		SBJsonParser *parser = [SBJsonParser new];
		id jsonData = [parser objectWithString:theData];
		
	   	if(!jsonData){
            
            
			
			[self showAlert:NSLocalizedString(@"errorTitle",@"~ Error ~") theMessage:NSLocalizedString(@"appParseError", @"There was a problem parsing some configuration data. Please make sure that it is well-formed") alertTag:0];
			[BT_fileManager deleteFile:[self saveAsFileName]];
            
		}else{
			
            [BT_debugger showIt:self message:@"is JSON"];
            
			if([jsonData objectForKey:@"childItems"]){
                [BT_debugger showIt:self message:@" if(jsonData)"];
				NSArray *tmpQuestions = [jsonData objectForKey:@"childItems"];
				for(NSDictionary *tmpQuestion in tmpQuestions){
					BT_item *thisWordPair = [[BT_item alloc] init];
					thisWordPair.itemId = [tmpQuestion objectForKey:@"itemId"];
					thisWordPair.itemType = [tmpQuestion objectForKey:@"itemType"];
					thisWordPair.jsonVars = tmpQuestion;
					[self.wordList addObject:thisWordPair];
				}
			}
			
			//layout screen
			[self getBTVars];
		}
		
	}@catch (NSException * e) {
        
		//delete bogus data, show alert
		[BT_fileManager deleteFile:[self saveAsFileName]];
		[self showAlert:NSLocalizedString(@"errorTitle",@"~ Error ~") theMessage:NSLocalizedString(@"appParseError", @"There was a problem parsing some configuration data. Please make sure that it is well-formed") alertTag:0];
		[BT_debugger showIt:self theMessage:[NSString stringWithFormat:@"error parsing screen data: %@", e]];
        
	}
    
    
}//end parseScreenData -----------------------

-(void)getWords{
    
    
}

-(void)fireGame{
    [BT_debugger showIt:self message:@"Fire Game"];
    
 
        //3 load the level, fire up the game
       // self.controller.unit = [Unit unitWithNum:unitNum];
        [self.controller dealRandomWord];
    
    
}





//level was selected, load it up and start the game
//-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    //1 check if the user tapped outside the menu
//    if (buttonIndex==-1) {
//        [self showLevelMenu];
//        return;
//    }
//    
//    //2 map index 0 to level 1, etc...
//    int unitNum = buttonIndex+1;
//    [BT_debugger showIt:self message:[NSString stringWithFormat:@"Unit Number : %d", unitNum]];
//    //3 load the level, fire up the game
//    self.controller.unit = [Unit unitWithNum:unitNum];
//    [self.controller dealRandomWord];
//}
/////////////////////////////////////////////////////////






- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
//downloader delegate methods

-(void)downloadFileStarted:(NSString *)message{
	[BT_debugger showIt:self theMessage:[NSString stringWithFormat:@"downloadFileStarted: %@", message]];
}

-(void)downloadFileInProgress:(NSString *)message{
    
	[BT_debugger showIt:self theMessage:[NSString stringWithFormat:@"downloadFileInProgress: %@", message]];
	if(self.progressView != nil){
		UILabel *tmpLabel = (UILabel *)[self.progressView.subviews objectAtIndex:2];
		[tmpLabel setText:message];
	}
    
}

-(void)downloadFileCompleted:(NSString *)message{
    
	[BT_debugger showIt:self theMessage:[NSString stringWithFormat:@"downloadFileCompleted: %@", message]];
	[self hideProgress];
	//NSLog(@"Message: %@", message);
    
	//if message contains "error", look for previously cached data...
	if([message rangeOfString:@"ERROR-1968" options:NSCaseInsensitiveSearch].location != NSNotFound){
        
		//show alert
		[self showAlert:nil theMessage:NSLocalizedString(@"downloadError", @"There was a problem downloading some data. Check your internet connection then try again.") alertTag:0];
        
		[BT_debugger showIt:self theMessage:[NSString stringWithFormat:@"download error: There was a problem downloading data from the internet.%@", @""]];
		if([BT_fileManager doesLocalFileExist:[self saveAsFileName]]){
            
			//use stale data if we have it
			NSString *staleData = [BT_fileManager readTextFileFromCacheWithEncoding:self.saveAsFileName encodingFlag:-1];
			
			[self parseScreenData:staleData];
			
		}else{
			
			[BT_debugger showIt:self theMessage:[NSString stringWithFormat:@"There is no local data available for this screen?%@", @""]];
            //	[self layoutScreen];
		}
        
	}else{
        
		//parse previously saved data
		if([BT_fileManager doesLocalFileExist:[self saveAsFileName]]){
			[BT_debugger showIt:self theMessage:[NSString stringWithFormat:@"parsing downloaded screen data.%@", @""]];
			NSString *downloadedData = [BT_fileManager readTextFileFromCacheWithEncoding:[self saveAsFileName] encodingFlag:-1];
            [BT_debugger showIt:self theMessage:@"fire parser"];
			[self parseScreenData:downloadedData];
            
		}else{
			[BT_debugger showIt:self theMessage:[NSString stringWithFormat:@"Error caching downloaded file: %@", [self saveAsFileName]]];
			//[self layoutScreen];
            
			//show alert
			[self showAlert:nil theMessage:NSLocalizedString(@"appDownloadError", @"There was a problem saving some data downloaded from the internet.") alertTag:0];
		}
	}
}


@end