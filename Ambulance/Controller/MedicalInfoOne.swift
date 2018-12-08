//
//  MedicalInfoController.swift
//  Ambulance
//
//  Created by Ramy on 12/1/18.
//  Copyright © 2018 Ramy. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import SVProgressHUD

class MedicalInfoOne: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource {
    private var datePicker: UIDatePicker?
    private var pickerView1: UIPickerView?
    private var pickerView2: UIPickerView?
     private let dataSource1 = ["Not Set","A+","A-","B+","B-","AB+","AB-","O+","O-"]
    private let dataSource2 = ["Not Set","Female","Male","Other"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        SVProgressHUD.setForegroundColor(UIColor.red)
        
        SetupPickerViewsForTextFields()
        DateOfBirthTextFieldPickerView()
        setupConstrains()
    }
    
    //   MARK :-  Main Methods
    /**********************************************************************************************/
    @objc func SignUpButtonAction(sender: UIButton!) {
        checkEmptyFields()
    }
    
    
    func SaveMedicalInfo(){
        guard let weight = WeightTextField.text,let height = HeightTextField.text, let date = DateOfBirthTextField.text, let blood = BloodTypeField.text, let sex = SexTextField.text  else {
            print("Form is not valid")
            return
        }
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        let userID = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(userID)
        let values = ["Weight": weight,"Height": height, "Date Of Birth": date, "Blood Type": blood, "Sex": sex]
        usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                let showError:String = error?.localizedDescription ?? ""
                self.dismissRingIndecator()
                SCLAlertView().showError("Error", subTitle: showError)
                return
            }
            self.dismissRingIndecator()
             // succeed ..
            let more = MedicalInfoTwo()
            self.navigationController?.pushViewController(more, animated: true)
        })
        
    }
    
    func checkEmptyFields(){
        guard let weight = WeightTextField.text,  WeightTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Enter your Weight!")
            return
        }
        guard let height = HeightTextField.text,  HeightTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Enter your Height!")
            return
        }
        guard let sex = SexTextField.text,  SexTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Sex is Empty!")
            return
        }
        guard let blood = BloodTypeField.text,  BloodTypeField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Enter Blood Type, or Select 'not set'!")
            return
        }
        guard let date = DateOfBirthTextField.text,  DateOfBirthTextField.text?.characters.count != 0 else {
            SCLAlertView().showError("Error", subTitle: "Enter your Date of Birth!")
            return
        }
        SaveMedicalInfo()
    }
    
    func dismissRingIndecator(){
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            SVProgressHUD.setDefaultMaskType(.none)
        }
    }
    
    //    MARK:- PickerView Methods
    /**********************************************************************************************/
    @objc func DateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        DateOfBirthTextField.text = dateFormatter.string(from: datePicker.date)
    }
    func DateOfBirthTextFieldPickerView(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        DateOfBirthTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(DateChanged(datePicker:)), for: .valueChanged)
    }
    func SetupPickerViewsForTextFields(){
        pickerView1 = UIPickerView()
        pickerView2 = UIPickerView()
        self.pickerView1?.delegate = self
        self.pickerView1!.dataSource = self
        self.pickerView2?.delegate = self
        self.pickerView2!.dataSource = self
        BloodTypeField.inputView = pickerView1
        SexTextField.inputView = pickerView2
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerView1 {
            return dataSource1.count
        }
        else if pickerView == pickerView2 {
            return dataSource2.count
        }
        else {
            return dataSource1.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1 {
            return dataSource1[row]
        }
        if pickerView == pickerView2 {
            return dataSource2[row]
        }
        else {
            return dataSource1[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1{
            BloodTypeField.text = dataSource1[pickerView1!.selectedRow(inComponent: 0)]
        }
        else if pickerView == pickerView2{
            SexTextField.text = dataSource2[pickerView2!.selectedRow(inComponent: 0)]
        }
    }
    
    
    //   MARK :- Constrains
    /**********************************************************************************************/
    private func setupConstrains(){
        
//        [SignUpButton,IconImage,LogInLabel,titleLabel,subTitleLabel].forEach { view.addSubview($0) }
//        [WeightTextField,HeightTextField,DateOfBirthTextField,BloodTypeField,SexTextField].forEach { view.addSubview($0) }
//
        view.addSubview(stackView5)
        view.addSubview(stackView4)
        view.addSubview(stackView3)
        view.addSubview(stackView2)
        view.addSubview(stackView1)
        
        stackView4.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 10, right: 0))
        
        stackView3.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: stackView4.frame.height/3) )
        
        
        stackView2.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30))
        
        
        
        
        
         stackView5.addArrangedSubview(WeightTextField)
         stackView5.addArrangedSubview(HeightTextField)
        
         stackView1.addArrangedSubview(titleLabel)
         stackView1.addArrangedSubview(subTitleLabel)
        
         stackView2.addArrangedSubview(stackView5)
         stackView2.addArrangedSubview(DateOfBirthTextField)
         stackView2.addArrangedSubview(BloodTypeField)
         stackView2.addArrangedSubview(SexTextField)
        
         stackView3.addArrangedSubview(LogInLabel)
         stackView3.addArrangedSubview(IconImage)
         stackView3.addArrangedSubview(stackView1)
        
          stackView4.addArrangedSubview(stackView3)
          stackView4.addArrangedSubview(stackView2)
          stackView4.addArrangedSubview(SignUpButton)
        
        
        WeightTextField.anchor(top: stackView5.topAnchor, leading: nil, bottom: stackView5.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        HeightTextField.anchor(top: stackView5.topAnchor, leading: nil, bottom: stackView5.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        
        
        
        
        
        stackView5.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        DateOfBirthTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        BloodTypeField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))
        SexTextField.anchor(top: nil, leading: stackView2.leadingAnchor, bottom: nil, trailing: stackView2.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 0))

        
        
        
        
        
        SignUpButton.anchor(top: nil, leading: stackView4.leadingAnchor, bottom: nil, trailing: stackView4.trailingAnchor, padding: .init(top: 0, left: 30, bottom: 0, right: 30),size: CGSize(width: 0, height: 50))
        //-------------
//        
//        LogInLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 0))
//        
//        
//        IconImage.anchor(top: LogInLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0),size: CGSize(width: 110, height: 110))
//        IconImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        
//        
//        titleLabel.anchor(top: IconImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 0, bottom: 0, right: 0))
//        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        
//        
//        subTitleLabel.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 0))
//        subTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        
//        WeightTextField.anchor(top: subTitleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 50, left: 20, bottom: 0, right: 0),size: CGSize(width: (self.view.frame.width/2)-20, height: 45))
//        
//        HeightTextField.anchor(top: subTitleLabel.bottomAnchor, leading: WeightTextField.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 50, left: 20, bottom: 0, right: 10),size: CGSize(width: (self.view.frame.width/2)-20, height: 45))
//        
//        DateOfBirthTextField.anchor(top: WeightTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 15, left: 20, bottom: 0, right: 10),size: CGSize(width: 0, height: 45))
//        
//        BloodTypeField.anchor(top: DateOfBirthTextField.bottomAnchor, leading: DateOfBirthTextField.leadingAnchor, bottom: nil, trailing: DateOfBirthTextField.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 45))
//        
//        SexTextField.anchor(top: BloodTypeField.bottomAnchor, leading: BloodTypeField.leadingAnchor, bottom: nil, trailing: BloodTypeField.trailingAnchor, padding: .init(top: 15, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 45))
//        
//        
//        SignUpButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 60, right: 20),size: CGSize(width: 0, height: 50))
//        
    }
    

    //   MARK :- Setup Component
    /**********************************************************************************************/
    let stackView2: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.fillEqually
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 15
        return sv
    }()
    let stackView1: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalSpacing
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 2.0
        return sv
    }()
    let stackView3: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.fill
        sv.alignment = UIStackView.Alignment.center
        sv.spacing   = 20.0
        return sv
    }()
    let stackView4: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.distribution  = UIStackView.Distribution.equalCentering
        sv.alignment = UIStackView.Alignment.center
        sv.spacing  = 30
        return sv
    }()
    
    let stackView5: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.horizontal
        sv.distribution  = UIStackView.Distribution.fillEqually
        sv.alignment = UIStackView.Alignment.center
        sv.spacing  = 20
        return sv
    }()
    
    
    
    let DateOfBirthTextField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Date of Birth"
        tx.font = UIFont.systemFont(ofSize: 15)
        tx.borderStyle = UITextField.BorderStyle.roundedRect
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.default
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let WeightTextField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Weight"
        tx.font = UIFont.systemFont(ofSize: 15)
        tx.borderStyle = UITextField.BorderStyle.roundedRect
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.numberPad
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let HeightTextField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Height"
        tx.font = UIFont.systemFont(ofSize: 15)
        tx.borderStyle = UITextField.BorderStyle.roundedRect
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.numberPad
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let BloodTypeField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Blood Type"
        tx.font = UIFont.systemFont(ofSize: 15)
        tx.borderStyle = UITextField.BorderStyle.roundedRect
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.default
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let SexTextField: UITextField = {
        let tx = UITextField(frame: CGRect(x: 20, y: 100, width: 250, height: 60))
        tx.placeholder = "Sex"
        tx.font = UIFont.systemFont(ofSize: 15)
        tx.borderStyle = UITextField.BorderStyle.roundedRect
        tx.autocorrectionType = UITextAutocorrectionType.no
        tx.keyboardType = UIKeyboardType.default
        tx.returnKeyType = UIReturnKeyType.done
        tx.clearButtonMode = UITextField.ViewMode.whileEditing;
        tx.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return tx
    }()
    let IconImage : UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "MedicalICON")
        image.layer.cornerRadius = 1
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    let LogInLabel : UILabel = {
        var label = UILabel()
        label.text = "Medical Information"
        label.tintColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        //  label.font = UIFont (name: "Rockwell-Bold", size: 30)
        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    let titleLabel : UILabel = {
        var label = UILabel()
        label.text = "We need some of your medical information \n in order to help you in emergency!"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 20)
        //   label.backgroundColor = UIColor.gray
        label.textAlignment = .center
        label.textColor = UIColor.gray
        return label
    }()
    let subTitleLabel : UILabel = {
        var label = UILabel()
        label.text = "Please fill all info required.."
        label.font = UIFont.systemFont(ofSize: 16)
        //   label.backgroundColor = UIColor.gray
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    let SignUpButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.setTitle("Next", for: .normal)
        button.frame.size = CGSize(width: 80, height: 100)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: ""), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(SignUpButtonAction), for: .touchUpInside)
        return button
    }()
    

    
    
}
