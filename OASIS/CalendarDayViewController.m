//
//  CalendarDayViewController.m
//  Demo
//
//  Created by Devin Ross on 3/16/13.
//
//

#import "CalendarDayViewController.h"

@implementation CalendarDayViewController

- (NSUInteger) supportedInterfaceOrientations{
	return  UIInterfaceOrientationMaskPortrait;
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}



- (void) viewDidLoad{
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Day View", @"");
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *info = [[NSDate date] dateComponentsWithTimeZone:gregorian.timeZone];
	info.hour = info.minute = info.second = 0;

    NSDate *newDate = [gregorian dateFromComponents:info];
    //NSLog(@"%@",info);
    NSLog(@"%@",newDate);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +0000"];
    NSDate *startDate = [dateFormatter dateFromString:@"2014-07-17 00:00:00 +0000"];
    //NSDate *endDate = [NSDate date];
    NSTimeInterval diff = [newDate timeIntervalSinceDate:startDate];
    NSLog(@"%f",diff/3600);
    
	self.data = @[
                  @[@"Meeting with five random dudes", @"Five Guys", @5, @0, @5, @30],
                  @[@"Unlimited bread rolls got me sprung", @"Olive Garden", @7, @0, @12, @0],
                  @[@"Appointment", @"Dennys", @15, @0, @18, @0],
                  @[@"Hamburger Bliss", @"Wendys", @15, @0, @18, @0],
                  @[@"Fishy Fishy Fishfelayyyyyyyy", @"McDonalds", @5, @30, @6, @0],
                  @[@"Turkey Time...... oh wait", @"Chick-fela", @14, @0, @19, @0],
                  @[@"Greet the king at the castle", @"Burger King", @19, @30, @30, @0]];
	
}
- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
    UIBarButtonItem *confirmationButton=[[UIBarButtonItem alloc]initWithTitle:@"Reserve" style:UIBarButtonItemStylePlain target:self action:@selector(confirmationButtonTapped:)];
    self.navigationItem.rightBarButtonItem=confirmationButton;
	self.navigationController.navigationBar.hairlineDividerView.hidden = YES;
	self.dayView.daysBackgroundView.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
}
- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.hairlineDividerView.hidden = NO;
    
}

-(void)confirmationButtonTapped:(UIBarButtonItem *)sender{
    
    //NSLog(@"%@",self.dayView.subviews);
    if(!self.dayView.reservationBlockExist){
        [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"No time slot has been selected" delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles:nil]show];
    }else if(!self.dayView.reservationIsValid){
        [[[UIAlertView alloc]initWithTitle:@"Warning" message:@"The selected time slot has already been reserved" delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles:nil]show];
        return;
    }else{
        [[[UIAlertView alloc]initWithTitle:@"Please confirm your reservation" message:[NSString stringWithFormat:@"%@\n%@ - %@\nWould you like to reserve this slot?",self.dayView.dateReservedTimeSlot,self.dayView.startReservedTimeSlot, self.dayView.endReservedTimeSlot] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm",nil]show];
    }
    
    
    //NSLog(@"%i",self.dayView.reservedTimeSlot);
}

#pragma mark TKCalendarDayViewDelegate
- (NSArray *) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventsForDate:(NSDate *)eventDate{
	
	//if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:-24*60*60]] == NSOrderedAscending) return @[];
	//if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:24*60*60]] == NSOrderedDescending) return @[];
    //NSLog(@"halo");
    
	NSDateComponents *info = [[NSDate date] dateComponentsWithTimeZone:calendarDayTimeline.calendar.timeZone];
    
	info.second = 0;
	NSMutableArray *ret = [NSMutableArray array];
	//NSLog(@"%@",self.data);
    
	for(NSArray *ar in self.data){
		
		TKCalendarDayEventView *event = [calendarDayTimeline dequeueReusableEventView];
		if(event == nil) event = [TKCalendarDayEventView eventView];
        
		event.identifier = nil;
		event.titleLabel.text = ar[0];
		event.locationLabel.text = ar[1];
		
		info.hour = [ar[2] intValue];
		info.minute = [ar[3] intValue];
		event.startDate = [NSDate dateWithDateComponents:info];
		//NSLog(@"s %@",event.startDate);
        
		info.hour = [ar[4] intValue];
		info.minute = [ar[5] intValue];
		event.endDate = [NSDate dateWithDateComponents:info];
        //NSLog(@"e %@",event.endDate);
        
		[ret addObject:event];
		
	}
	return ret;
	
    
}

- (void) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventViewWasSelected:(TKCalendarDayEventView *)eventView{
	TKLog(@"%@",eventView.titleLabel.text);
}


@end
