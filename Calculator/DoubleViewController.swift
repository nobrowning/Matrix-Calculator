
import UIKit

public protocol DoubleViewControllerDelegate {
    func doublePickViewClose(_ selected : Int,selected2: Int)
    func doubleCancles()
}

open class DoubleViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    var pickerData : NSArray!
    open var delegate2:DoubleViewControllerDelegate?
    
    @IBOutlet weak var picker: UIPickerView!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(){
        let resourcesBundle = Bundle(for:DoubleViewController.self)
        super.init(nibName: "DoubleViewController", bundle: resourcesBundle)
        
        self.pickerData = ["1", "2", "3", "4", "5"]
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open func showInView(_ superview : UIView) {
        
        if self.view.superview == nil {
            superview.addSubview(self.view)
        }
        
        self.view.center = CGPoint(x: self.view.center.x, y: 900)
        self.view.frame = CGRect(x: self.view.frame.origin.x , y: self.view.frame.origin.y , width: superview.frame.size.width, height: self.view.frame.size.height)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            self.view.center =  CGPoint(x: superview.center.x,y: superview.frame.size.height - self.view.frame.size.height/2)
            
        }, completion: nil)
        
    }


    open func hideInView() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            self.view.center =  CGPoint(x: self.view.center.x, y: 900)
            
        }, completion: nil)
    }
    
    @IBAction func done(_ sender: AnyObject) {
        self.hideInView()
        let selectedIndex = self.picker.selectedRow(inComponent: 0)
        let selectedIndex2 = self.picker.selectedRow(inComponent: 1)
        self.delegate2?.doublePickViewClose(selectedIndex,selected2: selectedIndex2)

    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.hideInView()
        self.delegate2?.doubleCancles()
    }
    
    //MARK: -- 实现协议UIPickerViewDelegate方法
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row] as? String
    }

    //MARK: -- 实现协议UIPickerViewDataSource方法
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
}
