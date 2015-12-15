//
//  ToolsLangViewController.m
//  DemoGuide
//
//  Created by Guillaume Kaisin on 13/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ToolsLangViewController.h"

@implementation ToolsLangViewController
@synthesize langList, appDelegate, lastIndexPath;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    self.appDelegate = (DemoGuideAppDelegate *)[[UIApplication sharedApplication] delegate];
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.langList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSString * lang = [self.langList objectAtIndex:indexPath.row];
    cell.textLabel.text = lang;
    
    //Put checkmark on the current language cell
    if(lang == [[self.appDelegate cacheManager] currentLang]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.lastIndexPath = indexPath;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *newCell =[tableView cellForRowAtIndexPath:indexPath];
    int newRow = [indexPath row];
    int oldRow = [self.lastIndexPath row];
    
    if(newRow != oldRow){
        //Modify the checkmark
        newCell = [tableView  cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath: lastIndexPath]; 
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        //Update the lastIndexPath
        lastIndexPath = indexPath;
        //Active language context
        NSString * newLangContext = [[[self.appDelegate contextManager] langContexts] objectAtIndex:newRow];
        NSString * oldLangContext = [[[self.appDelegate contextManager] langContexts] objectAtIndex:oldRow];
        [[SCContextManager sharedContextManager] deactivateContextWithName:oldLangContext];
        [[SCContextManager sharedContextManager] activateContextWithName:newLangContext];
    }
    //Deselect and pop the current view
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end