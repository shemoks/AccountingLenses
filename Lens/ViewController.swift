import UIKit
import CVCalendar
import RealmSwift

public struct InfoForNotification {
   var fireDate: NSDate
   let alertBody: String
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var appleLabel: UILabel!
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    @IBAction func okClick(sender: AnyObject) {
        addValue {
            self.getArrayOfDates { object in

            }
        }
    }
    
    @IBOutlet weak var daysOutSwitch: UISwitch!
    
    @IBOutlet weak var sliderValue: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBAction func slider(sender: AnyObject) {
        let value = Int(sliderValue.value)
        sliderLabel.text = "‹  " + String(value) + "  ›"
    }
    var arrayOfPasks: Results<Pask>!
    var arrayOfDates: [NSDate] = []
    var last = 0
   // var arrayOfFinishDates: [NSDate] = []
    var arrayInfoNotification: [InfoForNotification] = []
    
    @IBOutlet weak var monthLabel: UILabel!
    struct Color {
        static let selectedText = UIColor.whiteColor()
        static let text = UIColor.blackColor()
        static let textDisabled = UIColor.grayColor()
        static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0)
        static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
        static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
        static let sundaySelectionBackground = sundayText
    }
    var shouldShowDaysOut = true
    var animationFinished = true
    
    var selectedDay:DayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert , .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        monthLabel.text = CVDate(date: NSDate()).globalDescription
        getArrayOfDates { object in
            var info = InfoForNotification(fireDate: NSDate(), alertBody: "finish pasks! You must buy a new pask!")
            self.arrayInfoNotification = []
            var endPeriod = true
            if !object.isEmpty {
                let lastDate = object.last
                let calendar = NSCalendar.currentCalendar()
                var components = calendar.components([.Day , .Month , .Year], fromDate: lastDate!)
                let year =  components.year
                let month = components.month
                let day = components.day
                components = calendar.components([.Day , .Month , .Year], fromDate: NSDate())
                let yearNow =  components.year
                let monthNow = components.month
                let dayNow = components.day
                if dayNow + 10 >= day && yearNow == year && monthNow == month {
                    endPeriod = false
                    for obj in object {
                        info.fireDate = obj
                        self.arrayInfoNotification.append(info)
                    }
                }
                self.sendNotification()
            }
            if endPeriod {
                self.appleLabel.text = ""
            } else {
                self.appleLabel.text = ""
            }
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        calendarView.toggleCurrentDayView()
        
    }
    func getArray(obj: (Results<Pask>) -> ()){
        arrayOfPasks = HelperPask.getAllPask()
        dispatch_async(dispatch_get_main_queue(), {
            obj(self.arrayOfPasks)
        })
    }
    
//    func getInfoForNotification (resultForNotification: ([NSDate]) -> ()){
//        getArray {object in
//            for obj in object {
//            self.arrayOfFinishDates.append(obj.dateFinish)
//            }
//            dispatch_async(dispatch_get_main_queue(), {
//                resultForNotification(self.arrayOfFinishDates)
//            })
//        }
//    }
    
    func getArrayOfDates(obj: ([NSDate]) -> ()){
        getArray {object in
            if !object.isEmpty {
                self.removeDates {objects in
            self.arrayOfDates = HelperPask().arrayOfDates(objects)
        }
        }
            dispatch_async(dispatch_get_main_queue(), {
                obj(self.arrayOfDates)
            })
        }
    }
    func removeDates(obj: (Results<Pask>) -> ()){
        arrayOfPasks = HelperPask.removePasc()
        dispatch_async(dispatch_get_main_queue(), {
            obj(self.arrayOfPasks)
        })
    }
    func addValue(object: () -> ()) {
        HelperPask().addValueToDate(Int(sliderValue.value), pasks: self.arrayOfPasks)
    }
    

    
    func sendNotification() {
       let info = self.arrayInfoNotification
       Notification(atributiesOfNotifications: info).getNotification()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        getArrayOfDates { object in
            var endPeriod = false
            if !object.isEmpty {
                let lastDate = object.last
                let calendar = NSCalendar.currentCalendar()
                var components = calendar.components([.Day , .Month , .Year], fromDate: lastDate!)
                let year =  components.year
                let month = components.month
                let day = components.day
                components = calendar.components([.Day , .Month , .Year], fromDate: NSDate())
                let yearNow =  components.year
                let monthNow = components.month
                let dayNow = components.day
                if dayNow + 10 >= day && yearNow == year && monthNow == month {
                    endPeriod = true
                }
            }
            if endPeriod {
                self.appleLabel.text = ""
            } else {
                self.appleLabel.text = ""
            }
            
            self.calendarView.contentController.refreshPresentedMonth()
            self.menuView.commitMenuViewUpdate()
            self.calendarView.commitCalendarViewUpdate()
        }
    }
    
}


extension ViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    // MARK: Optional methods
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return weekday == .Sunday ? UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0) : UIColor.whiteColor()
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    //    func shouldAnimateResizing() -> Bool {
    //        return true // Default value is true
    //    }
    //
    //    func shouldSelectDayView(dayView: DayView) -> Bool {
    //        return arc4random_uniform(33) == 0 ? true : false
    //    }
    //
//    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
//        print("\(dayView.date.commonDescription) is selected!")
//        selectedDay = dayView
//    }
    
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransformIdentity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
       
        }
    }
    
    //    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
    //        return true
    //    }
    //
    //    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
    //        let day = dayView.date.day
    //        let randomDay = Int(arc4random_uniform(31))
    //        if day == randomDay {
    //            return true
    //        }
    //
    //        return false
    //    }
    
    //    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
    //
    //        let red = CGFloat(arc4random_uniform(600) / 255)
    //        let green = CGFloat(arc4random_uniform(600) / 255)
    //        let blue = CGFloat(arc4random_uniform(600) / 255)
    //
    //        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
    //
    //        let numberOfDots = Int(arc4random_uniform(3) + 1)
    //        switch(numberOfDots) {
    //        case 2:
    //            return [color, color]
    //        case 3:
    //            return [color, color, color]
    //        default:
    //            return [color] // return 1 dot
    //        }
    //    }
    
    //    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
    //        return true
    //    }
    //
    //    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
    //        return 13
    //    }
    
    
    //    func weekdaySymbolType() -> WeekdaySymbolType {
    //        return .Short
    //    }
    ////
    //    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
    //        return { UIBezierPath(rect: CGRectMake(0, 0, $0.width, $0.height)) }
    //    }
    
//        func shouldShowCustomSingleSelection() -> Bool {
//            return true
//        }
    //
//        func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
//            let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
//            circleView.fillColor = .colorFromCode(0xCCCCCC)
//            return circleView
//        }
////
//        func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
//            if (dayView.isCurrentDay) {
//                return true
//            }
//            return false
//        }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        let π = M_PI
        
        let ringSpacing: CGFloat = 3.0
        let ringInsetWidth: CGFloat = 1.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour: UIColor = .blueColor()
        let ringLastLineColour: UIColor = .redColor()
        
        let newView = UIView(frame: dayView.bounds)
        
        let diameter: CGFloat = (newView.bounds.width) - ringSpacing - 10
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        if last == 0 {
            ringLayer.strokeColor = ringLineColour.CGColor
        } else {
            ringLayer.strokeColor = ringLastLineColour.CGColor
        }
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
        let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.CGPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        last = 0
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
        var k = 0
        for obj in arrayOfDates {
            k += 1
            if k>1 {
                let calendar = NSCalendar.currentCalendar()
                var components = calendar.components([.Day , .Month , .Year], fromDate: obj)
                let year =  components.year
                let month = components.month
                let day = components.day
                components = calendar.components([.Day , .Month , .Year], fromDate: NSDate())
                let yearNow =  components.year
                let monthNow = components.month
                let dayNow = components.day
                if k == arrayOfDates.count {
                    last = 1
                }
                if (day >= dayNow || year > yearNow || month > monthNow) && dayView.date != nil && day == dayView.date.day && month == dayView.date.month && year == dayView.date.year {
                    return true
                }
                
            }
        }
        return false
    }
    func dayOfWeekTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    func dayOfWeekBackGroundColor() -> UIColor {
        return UIColor.grayColor()
    }
}


// MARK: - CVCalendarViewAppearanceDelegate

extension ViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.systemFontOfSize(14) }
    
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .Selected, _), (_, .Highlighted, _): return Color.selectedText
        case (.Sunday, .In, _): return Color.sundayText
        case (.Sunday, _, _): return Color.sundayTextDisabled
        case (_, .In, _): return Color.text
        default: return Color.textDisabled
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (.Sunday, .Selected, _), (.Sunday, .Highlighted, _): return Color.sundaySelectionBackground
        case (_, .Selected, _), (_, .Highlighted, _): return Color.selectionBackground
        default: return nil
        }
    }
}


// MARK: - CVCalendarViewAppearanceDelegate


// MARK: - IB Actions

extension ViewController {
//    @IBAction func switchChanged(sender: UISwitch) {
//        if sender.on {
//            calendarView.changeDaysOutShowingState(false)
//            shouldShowDaysOut = true
//        } else {
//            calendarView.changeDaysOutShowingState(true)
//            shouldShowDaysOut = false
//        }
//    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to WeekView mode.
    //    @IBAction func toWeekView(sender: AnyObject) {
    //        calendarView.changeMode(.WeekView)
    //    }
    
    /// Switch to MonthView mode.
    //    @IBAction func toMonthView(sender: AnyObject) {
    //        calendarView.changeMode(.MonthView)
    //    }
    //
    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
}

// MARK: - Convenience API Demo

extension ViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    func didShowNextMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
    
    func didShowPreviousMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
}