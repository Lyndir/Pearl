//
//  PrivacyVC.m
//
//  Created by Maarten Billemont on 05/11/10.
//  Copyright 2010 Lhunath. All rights reserved.
//

#import "ArrayTVC.h"
#import "ObjectUtils.h"

#define PearlATVCCellID         @"Pearl.ArrayTVC.cell"
#define PearlATVCRowName        @"Pearl.ArrayTVC.name"
#define PearlATVCRowDetail      @"Pearl.ArrayTVC.detail"
#define PearlATVCRowStyle       @"Pearl.ArrayTVC.style"
#define PearlATVCRowToggled     @"Pearl.ArrayTVC.toggled"
#define PearlATVCRowDelegate    @"Pearl.ArrayTVC.delegate"
#define PearlATVCRowContext     @"Pearl.ArrayTVC.context"
#define PearlATVCCellStyle      @"Pearl.ArrayTVC.cellstyle"

@interface ArrayTVC() 

- (NSString *)toString:(UITableViewCellStyle)cellStyle;

- (void)addRowWithName:(NSString *)aName withDetail:(NSString *)aDetail cellStyle:(UITableViewCellStyle)aCellStyle rowStyle:(ArrayTVCRowStyle)aRowStyle toggled:(BOOL)isToggled toSection:(NSString *)aSection withDelegate:(id<ArrayTVCDelegate>)aDelegate context:(id)aContext;
@end

@implementation ArrayTVC

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (!(self = [super initWithCoder:aDecoder]))
        return self;
    
    _sections = [NSMutableArray new];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)removeAllRows {
    
    [_sections removeAllObjects];
}

- (void)removeRowWithName:(NSString *)aName fromSection:(NSString *)aSection {
    
    for (NSDictionary *section in _sections)
        if (!aSection || [[[section allKeys] lastObject] isEqualToString:aSection]) {
            NSMutableArray *sectionRows = [[section allValues] lastObject];
            
            for (NSDictionary *row in sectionRows)
                if ((aName == nil && [row objectForKey:PearlATVCRowName] == [NSNull null]) ||
                    [[row objectForKey:PearlATVCRowName] isEqualToString:aName]) {
                    [sectionRows removeObject:row];
                    return;
                }
        }
}

- (void)removeRowWithContext:(id)aContext fromSection:(NSString *)aSection {
    
    for (NSDictionary *section in _sections)
        if (!aSection || [[[section allKeys] lastObject] isEqualToString:aSection]) {
            NSMutableArray *sectionRows = [[section allValues] lastObject];
            
            for (NSDictionary *row in sectionRows)
                if (NSNullToNil([row objectForKey:PearlATVCRowContext]) == aContext) {
                    [sectionRows removeObject:row];
                    return;
                }
        }
}


- (void)addRowWithName:(NSString *)aName style:(ArrayTVCRowStyle)aStyle toggled:(BOOL)isToggled toSection:(NSString *)aSection
          withDelegate:(id<ArrayTVCDelegate>)aDelegate context:(id)aContext {
    
    
    [self addRowWithName:aName withDetail:nil cellStyle:UITableViewCellStyleDefault rowStyle:aStyle toggled:isToggled toSection:aSection withDelegate:aDelegate context:aContext];
}

- (void)addRowWithName:(NSString *)aName withDetail:(NSString *)aDetail toSection:(NSString *)aSection withDelegate:(id<ArrayTVCDelegate>)aDelegate 
            context:(id)aContext {

    [self addRowWithName:aName withDetail:aDetail cellStyle:UITableViewCellStyleValue1 rowStyle:ArrayTVCRowStylePlain toggled:NO toSection:aSection withDelegate:aDelegate context:aContext];
}

- (void)addRowWithName:(NSString *)aName withDetail:(NSString *)aDetail cellStyle:(UITableViewCellStyle)aCellStyle rowStyle:(ArrayTVCRowStyle)aRowStyle toggled:(BOOL)isToggled toSection:(NSString *)aSection withDelegate:(id<ArrayTVCDelegate>)aDelegate context:(id)aContext {
    
    NSMutableArray *sectionRows = nil;
    for (NSDictionary *section in _sections)
        if ([[[section allKeys] lastObject] isEqualToString:aSection]) {
            sectionRows = [[section allValues] lastObject];
            break;
        }
    if (!sectionRows)
        [_sections addObject:[NSDictionary dictionaryWithObject:sectionRows = [NSMutableArray array] forKey:aSection]];
    
    [sectionRows addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                            NilToNSNull(aName),                                             PearlATVCRowName,
                            NilToNSNull(aDetail),                                           PearlATVCRowDetail,
                            [NSNumber numberWithUnsignedInt:aRowStyle],                     PearlATVCRowStyle,
                            [NSNumber numberWithUnsignedInt:aCellStyle],                    PearlATVCCellStyle,
                            [NSNumber numberWithBool:isToggled],                            PearlATVCRowToggled,
                            NilToNSNull(aDelegate),                                         PearlATVCRowDelegate,
                            NilToNSNull(aContext),                                          PearlATVCRowContext,
                            nil]];
}

- (void)customizeCell:(UITableViewCell *)cell forRow:(NSDictionary *)row withContext:(id)context {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    
    return [(NSArray *) [[[_sections objectAtIndex:section] allValues] lastObject] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[[_sections objectAtIndex:section] allKeys] lastObject];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *sectionRows = [[[_sections objectAtIndex:indexPath.section] allValues] lastObject];
    NSDictionary *row = [sectionRows objectAtIndex:indexPath.row];
    
    UITableViewCellStyle cellStyle = [NSNullToNil([row objectForKey:PearlATVCCellStyle]) unsignedIntValue];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self toString:cellStyle]];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:[self toString:cellStyle]] autorelease];
    
    
    cell.textLabel.text = NSNullToNil([row objectForKey:PearlATVCRowName]);
    cell.detailTextLabel.text = NSNullToNil([row objectForKey:PearlATVCRowDetail]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    switch ([NSNullToNil([row objectForKey:PearlATVCRowStyle]) unsignedIntValue]) {
        case ArrayTVCRowStylePlain:
            break;
        case ArrayTVCRowStyleLink: {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        }
        case ArrayTVCRowStyleDisclosure: {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case ArrayTVCRowStyleCheck: {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            if ([[row objectForKey:PearlATVCRowToggled] boolValue])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
        case ArrayTVCRowStyleToggle: {
            UISwitch *switchView = [[[UISwitch alloc] init] autorelease];
            switchView.on = [[row objectForKey:PearlATVCRowToggled] boolValue];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryView = switchView;
            break;
        }
    }
    
    [self customizeCell:cell forRow:row withContext:NSNullToNil([row objectForKey:PearlATVCRowContext])];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *sectionName = [[[_sections objectAtIndex:indexPath.section] allKeys] lastObject];
    NSArray *sectionRows = [[[_sections objectAtIndex:indexPath.section] allValues] lastObject];
    NSMutableDictionary *row = [sectionRows objectAtIndex:indexPath.row];
    
    BOOL newToggled = ![[row objectForKey:PearlATVCRowToggled] boolValue];
    if ([NSNullToNil([row objectForKey:PearlATVCRowDelegate]) shouldActivateRowNamed:NSNullToNil([row objectForKey:PearlATVCRowName])
                                                                           inSection:sectionName
                                                                         withContext:NSNullToNil([row objectForKey:PearlATVCRowContext])
                                                                            toggleTo:newToggled]) {
        [row setObject:[NSNumber numberWithBool:newToggled] forKey:PearlATVCRowToggled];
        switch ([NSNullToNil([row objectForKey:PearlATVCRowStyle]) unsignedIntValue]) {
            case ArrayTVCRowStyleToggle: {
                [(UISwitch *)[[self.tableView cellForRowAtIndexPath:indexPath] accessoryView] setOn:newToggled animated:YES];
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                break;
            }
            case ArrayTVCRowStyleCheck: {
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
            default:
                break;
        }
    }
}

- (NSString *)toString:(UITableViewCellStyle)cellStyle {
    
    switch(cellStyle) {
            
        case UITableViewCellStyleDefault:
            return @"UITableViewCellStyleDefault";
        case UITableViewCellStyleValue1:
            return @"UITableViewCellStyleValue1";
        case UITableViewCellStyleValue2:
            return @"UITableViewCellStyleValue2";
        case UITableViewCellStyleSubtitle:
            return @"UITableViewCellStyleSubtitle";            
    }
    
    wrn(@"Unexpected cell style: %d", cellStyle);
    return nil;
}

@end
