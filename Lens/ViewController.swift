import UIKit
import CVCalendar
import RealmSwift

public struct massDates{
    var date: NSDate
    var color: UIColor
    var enabled: Bool
}
public struct location{
    var x: CGFloat
    var y: CGFloat
}

class ViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    
    
    @IBOutlet weak var collectionView: View!
    @IBOutlet weak var appleLabel: UILabel!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var daysOutSwitch: UISwitch!
    @IBOutlet weak var sliderValue: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var arrayOfPasks: Results<Pask>!
    var arrayOfDates: [NSDate] = []
    var last = 0
    var shouldShowDaysOut = true
    var animationFinished = true
    var indexDate: NSDate = NSDate()
    var massDaysForSlider: [massDates] = []
    var viewController: SliderViewController!
    var coordinates: location = location(x: 0, y: 0)

    
    //    @IBAction func okClick(sender: AnyObject) {
    ////        addValue {
    ////            self.getArrayOfDates { object in
    ////            }
    ////        }
    //    }
    
    //    @IBAction func slider(sender: AnyObject) {
    //        let value = Int(sliderValue.value)
    //        sliderLabel.text = "‹  " + String(value) + "  ›"
    //    }
    
    struct Color {
        static let selectedText = UIColor.whiteColor()
        static let text = UIColor.blackColor()
        static let textDisabled = UIColor.grayColor()
        static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0)
        static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
        static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
        static let sundaySelectionBackground = sundayText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert , .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        monthLabel.text = CVDate(date: NSDate()).globalDescription
        getArrayOfDates { object in
            self.compareDates(object)
            self.collectionView.arrayOfPasks = HelperPask.numberOfLenses(self.arrayOfPasks)
            self.collectionView.onTouch = { () in
                self.performSegueWithIdentifier("addPask", sender: self)
            }
            self.collectionView.collectionView.reloadData()
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getArrayOfDates { object in
            self.compareDates(object)
            self.calendarView.contentController.refreshPresentedMonth()
            self.menuView.commitMenuViewUpdate()
            self.calendarView.commitCalendarViewUpdate()
        }
       
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .None
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        getArrayOfDates { object in
            self.calendarView.toggleCurrentDayView()
            self.collectionView.arrayOfPasks = HelperPask.numberOfLenses(self.arrayOfPasks)
            self.collectionView.onTouch = { () in
                self.performSegueWithIdentifier("addPask", sender: self)
            }
            self.collectionView.collectionView.reloadData()
            self.calendarView.contentController.refreshPresentedMonth()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? UINavigationController
            where segue.identifier == "addDay" {
            self.viewController = vc.viewControllers.first as! SliderViewController
            self.viewController.arrayOfDates = self.massDaysForSlider
            self.viewController.arrayOfPasks = self.arrayOfPasks
            let controller = vc.popoverPresentationController
            vc.preferredContentSize = CGSize(width: 300, height: 70)
            //controller.frame.origin.x = coordinates.x + 135
            
     //       vc.preferredContentSize = CGRectMake(0, coordinates.y, 600, 70)
        
            controller!.sourceRect = CGRect(x: coordinates.x - 135, y: coordinates.y + 60, width: 300.0, height: 70.0)
            if controller != nil {
                controller?.delegate = self
            }
        }
    }
    
    func getArray(obj: (Results<Pask>) -> ()){
        arrayOfPasks = HelperPask.getAllPask()
        dispatch_async(dispatch_get_main_queue(), {
            obj(self.arrayOfPasks)
        })
    }
    
    func compareDates(object: [NSDate]) {
        
        if !object.isEmpty {
            var endPeriod = false
            let lastDate = object.last
            let now = NSDate()
            let dayTomorrow = HelperDates.addValueToDate(now, value: 10)
            if HelperDates.compareDates(dayTomorrow, secondDate: lastDate!) == ">" || HelperDates.compareDates(dayTomorrow, secondDate: lastDate!) == "=" {
                endPeriod = true
            }
            if endPeriod {
                self.appleLabel.text = ""
            } else {
                self.appleLabel.text = ""
            }
        }
    }
    
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
    
    //    func addValue(object: () -> ()) {
    //        HelperPask().addValueToDate(indexDate, value: Int(sliderValue.value), pasks: self.arrayOfPasks)
    //    }
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
//        func shouldSelectDayView(dayView: DayView) -> Bool {
//            let dateComponents = NSDateComponents()
//            dateComponents.day = dayView.date.day
//            dateComponents.month = dayView.date.month
//            dateComponents.year = dayView.date.year
//            let calendar = NSCalendar.currentCalendar()
//            let currentDate = calendar.dateFromComponents(dateComponents)
//            for date in arrayOfDates {
//                if HelperDates.compareDates(date, secondDate: currentDate!) == "=" && HelperDates.compareDates(NSDate(), secondDate: currentDate!) == "<" {
//                   return true
//                }
//            }
//            return  false
//        }
    
            func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
                var flag = false
                massDaysForSlider = []
                var structForSlider = massDates(date: NSDate(), color:.blueColor(), enabled: true)
                let dateComponents = NSDateComponents()
                dateComponents.day = dayView.date.day
                dateComponents.month = dayView.date.month
                dateComponents.year = dayView.date.year
                let calendar = NSCalendar.currentCalendar()
                let currentDate = calendar.dateFromComponents(dateComponents)
                for date in arrayOfDates {
                    if HelperDates.compareDates(date, secondDate: currentDate!) == "=" && HelperDates.compareDates(NSDate(), secondDate: currentDate!) == "<" && HelperDates.compareDates(arrayOfDates.last!, secondDate: currentDate!) != "="{
                    flag = true
                    }
                }
                if flag {
                let finishDate = HelperDates.addValueToDate(currentDate!, value: 8)
                var firstDate = HelperDates.addValueToDate(currentDate!, value: -1)
                while HelperDates.compareDates(firstDate, secondDate: finishDate) != "=" {
                    if HelperDates.compareDates(firstDate, secondDate: currentDate!) == "<" {
                      structForSlider.enabled = false
                      structForSlider.date = firstDate
                        structForSlider.color = .grayColor()
                      massDaysForSlider.append(structForSlider)
                    }
                    if  HelperDates.compareDates(firstDate, secondDate: currentDate!) == ">" {
                        structForSlider.enabled = true
                        structForSlider.color = .whiteColor()
                        structForSlider.date = firstDate
                        massDaysForSlider.append(structForSlider)
                    }
                    if  HelperDates.compareDates(firstDate, secondDate: currentDate!) == "=" {
                        structForSlider.enabled = true
                        structForSlider.date = firstDate
                        structForSlider.color = .redColor()
                        massDaysForSlider.append(structForSlider)
                    }
                    firstDate = HelperDates.addValueToDate(firstDate, value: 1)
                }
                    if HelperDates.compareDates(firstDate, secondDate: finishDate) == "=" {
                        structForSlider.enabled = false
                        structForSlider.date = firstDate
                        structForSlider.color = .grayColor()
                        massDaysForSlider.append(structForSlider)
                    
                    }
                    
                    self.coordinates.x = dayView.frame.origin.x

                    
                   // self.coordinates.y = dayView.layer.bounds.origin.y
                    
                self.coordinates.y = dayView.weekView.frame.origin.y - 60
                    print("\(self.coordinates.x)")
                    print("\(self.coordinates.y)")
                    self.performSegueWithIdentifier("addDay", sender: self)
            }
    }
    
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
    
//            func shouldShowCustomSingleSelection() -> Bool {
//                return true
//            }
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
    func shouldAutoSelectDayOnMonthChange() -> Bool {
     return false
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        let π = M_PI
        let ringSpacing: CGFloat = 3.0
        let ringInsetWidth: CGFloat = 1.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour: UIColor = .grayColor()
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
                var lastDateStructure = dateStruct(day: 0, month: 0, year: 0)
                var nowDateStructure = dateStruct(day: 0, month: 0, year: 0)
                lastDateStructure = HelperDates.getDateAsStruct(obj)
                nowDateStructure = HelperDates.getDateAsStruct(NSDate())
                if k == arrayOfDates.count {
                    last = 1
                }
                if (lastDateStructure.day >= nowDateStructure.day || lastDateStructure.year > nowDateStructure.year || lastDateStructure.month > nowDateStructure.month) && dayView.date != nil && lastDateStructure.day == dayView.date.day && lastDateStructure.month == dayView.date.month && lastDateStructure.year == dayView.date.year {
                    
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
        let components = Manager.componentsForDate(NSDate())
        components.month += offset
        let resultDate = calendar.dateFromComponents(components)!
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    func didShowNextMonthView(date: NSDate) {
        let components = Manager.componentsForDate(date)
        print("Showing Month: \(components.month)")
    }
    
    func didShowPreviousMonthView(date: NSDate) {
        let components = Manager.componentsForDate(date)
        print("Showing Month: \(components.month)")
    }
}