/*
 * Copyright (c) 2014-present Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

// A delay function
func delay(seconds: Double, completion: @escaping ()-> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

func tintBackgroundColor(layer: CALayer, toColor color: UIColor) {
	let tintBackground = CASpringAnimation(keyPath: "backgroundColor")
		tintBackground.fromValue = layer.backgroundColor
		tintBackground.toValue	 = color
		tintBackground.duration = 1.0

		tintBackground.damping = 10.0
		tintBackground.initialVelocity = 0.0
		tintBackground.stiffness = 100.0
		tintBackground.mass = 1.0
		tintBackground.duration = tintBackground.settlingDuration

	layer.add(tintBackground, forKey: nil)
	layer.backgroundColor = color.cgColor
}

func roundCorners(layer: CALayer, toRadius radius: CGFloat) {
	let roundCorners = CASpringAnimation(keyPath: "cornerRadius")
		roundCorners.fromValue = layer.cornerRadius
		roundCorners.toValue = radius
		roundCorners.duration = 0.33

		roundCorners.damping = 10.0
		roundCorners.initialVelocity = 0.0
		roundCorners.stiffness = 100.0
		roundCorners.mass = 1.0
		roundCorners.duration = roundCorners.settlingDuration

	layer.add(roundCorners, forKey: nil)
	layer.cornerRadius = radius
}

class ViewController: UIViewController {

  // MARK: IB outlets

  @IBOutlet var loginButton: UIButton!
  @IBOutlet var heading: UILabel!
  @IBOutlet var username: UITextField!
  @IBOutlet var password: UITextField!

  @IBOutlet var cloud1: UIImageView!
  @IBOutlet var cloud2: UIImageView!
  @IBOutlet var cloud3: UIImageView!
  @IBOutlet var cloud4: UIImageView!

	var cloudViews: [UIView] = [UIView]()

  // MARK: further UI

  let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  let status = UIImageView(image: UIImage(named: "banner"))
  let label = UILabel()
	let info = UILabel()
  let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]

  var statusPosition = CGPoint.zero

  // MARK: view controller methods

  override func viewDidLoad() {
    super.viewDidLoad()

	cloudViews = [cloud1, cloud2, cloud3, cloud4]

    //set up the UI
    loginButton.layer.cornerRadius = 8.0
    loginButton.layer.masksToBounds = true

    spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
    spinner.startAnimating()
    spinner.alpha = 0.0
    loginButton.addSubview(spinner)

    status.isHidden = true
    status.center = loginButton.center
    view.addSubview(status)

    label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18.0)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
    label.textAlignment = .center
    status.addSubview(label)

    statusPosition = status.center

	info.frame = CGRect(x: 0.0, y: loginButton.center.y + 60.0, width: view.frame.size.width, height: 30)
	info.backgroundColor = UIColor.clear
	info.font = UIFont(name: "HelveticaNeue", size: 12.0)
	info.textAlignment = .center
	info.textColor = UIColor.white
	info.text = "Tap on a field and enter username and password"
	view.insertSubview(info, belowSubview: loginButton)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

	let flyRight = CABasicAnimation(keyPath: "position.x")
	flyRight.fromValue = -view.bounds.size.width/2
	flyRight.toValue = view.bounds.size.width/2
	flyRight.duration = 0.5
	//	this ends the presentation layer, but the actual object layer is not in this location
	//	flyRight.isRemovedOnCompletion = false
	//Adjust the fill mode to ensure the animation begins outside at the start of the animation frames and ends at the end of the frames
//	flyRight.fillMode = kCAFillModeBoth


	let fadeIn = CABasicAnimation(keyPath: "opacity")
	fadeIn.fromValue = 0.0
	fadeIn.toValue = 1.0
	fadeIn.duration = 0.5
	fadeIn.fillMode = kCAFillModeBackwards

	for (index, cloudView) in cloudViews.enumerated() {
		fadeIn.beginTime = CACurrentMediaTime() + 0.5 + (0.2 * Double(index))
		cloudView.layer.add(fadeIn, forKey: nil)

		print(fadeIn.beginTime)
	}

	let labelEntryAnimation = CAAnimationGroup()
		labelEntryAnimation.animations = [flyRight, fadeIn]
		labelEntryAnimation.delegate = self
		labelEntryAnimation.setValue("form", forKey: "name")
		labelEntryAnimation.fillMode = kCAFillModeBoth


	labelEntryAnimation.setValue(heading.layer, forKey: "layer")
	heading.layer.add(labelEntryAnimation, forKey: nil)

	labelEntryAnimation.beginTime = CACurrentMediaTime() + 0.3
	labelEntryAnimation.setValue(username.layer, forKey: "layer")
	username.layer.add(labelEntryAnimation, forKey: nil)

	labelEntryAnimation.beginTime = CACurrentMediaTime() + 0.4
	labelEntryAnimation.setValue(password.layer, forKey: "layer")
	password.layer.add(labelEntryAnimation, forKey: nil)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

	//creating a basic group animation allows you to control the properties of the associated animations all as one unit
	let groupAnimation = CAAnimationGroup()
		groupAnimation.beginTime = CACurrentMediaTime() + 0.5
		groupAnimation.duration = 0.5
		groupAnimation.fillMode = kCAFillModeBackwards
		//adding a timing function adds a slight realistic touch
		groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

	let scaleDown = CABasicAnimation(keyPath: "transform.scale")
		scaleDown.fromValue = 3.5
		scaleDown.toValue = 1.0
	let rotate = CABasicAnimation(keyPath: "transform.rotation")
		rotate.fromValue = .pi / 4.0
		rotate.toValue = 0.0
	let fade = CABasicAnimation(keyPath: "opacity")
		fade.fromValue = 0.0
		fade.toValue = 1.0

	groupAnimation.animations = [scaleDown, rotate, fade]
	loginButton.layer.add(groupAnimation, forKey: nil)

	let flyLeft = CABasicAnimation(keyPath: "position.x")
	flyLeft.fromValue 	= info.layer.position.x + view.frame.size.width
	flyLeft.toValue 	= info.layer.position.x
	flyLeft.duration	= 5.0
//	flyLeft.repeatCount = 2.5
//	flyLeft.autoreverses = true
//	flyLeft.speed = 2.0
//	info.layer.speed = 2.0
//	view.layer.speed = 2.0
	info.layer.add(flyLeft, forKey: "infoappear")

	let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
		fadeLabelIn.fromValue	= 0.2
		fadeLabelIn.toValue		= 1.0
		fadeLabelIn.duration	= 4.5

	info.layer.add(fadeLabelIn, forKey: "fadein")

	username.delegate = self
	password.delegate = self

	for cloudView in cloudViews {
		animateCloud(cloudView.layer)
	}
}

  func showMessage(index: Int) {
    label.text = messages[index]

    UIView.transition(with: status, duration: 0.33,
      options: [.curveEaseOut, .transitionFlipFromBottom],
      animations: {
        self.status.isHidden = false
      },
      completion: {_ in
        //transition completion
        delay(seconds: 2.0) {
          if index < self.messages.count-1 {
            self.removeMessage(index: index)
          } else {
            //reset form
            self.resetForm()
          }
        }
      }
    )
  }

  func removeMessage(index: Int) {

    UIView.animate(withDuration: 0.33, delay: 0.0,
      animations: {
        self.status.center.x += self.view.frame.size.width
      },
      completion: {_ in
        self.status.isHidden = true
        self.status.center = self.statusPosition

        self.showMessage(index: index+1)
      }
    )
  }

  func resetForm() {
    UIView.transition(with: status, duration: 0.2, options: .transitionFlipFromTop,
      animations: {
        self.status.isHidden = true
        self.status.center = self.statusPosition
      },
      completion: nil
    )

    UIView.animate(withDuration: 0.2, delay: 0.0,
      animations: {
        self.spinner.center = CGPoint(x: -20.0, y: 16.0)
        self.spinner.alpha = 0.0
//        self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
        self.loginButton.bounds.size.width -= 80.0
        self.loginButton.center.y -= 60.0
      },
	  completion: { _ in
		let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
		tintBackgroundColor(layer: self.loginButton.layer, toColor: tintColor)

		roundCorners(layer: self.loginButton.layer, toRadius: 10.0)
	}
    )
  }

  // MARK: further methods

  @IBAction func login() {
    view.endEditing(true)

    UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.2,
      initialSpringVelocity: 0.0,
      animations: {
        self.loginButton.bounds.size.width += 80.0
      },
      completion: {_ in
        self.showMessage(index: 0)
      }
    )

    UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.0,
      animations: {
        self.loginButton.center.y += 60.0
//        self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
        self.spinner.center = CGPoint(x: 40.0, y: self.loginButton.frame.size.height/2)
        self.spinner.alpha = 1.0
      },
      completion: nil
    )

	let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
		tintBackgroundColor(layer: loginButton.layer, toColor: tintColor)

	roundCorners(layer: loginButton.layer, toRadius: 25.0)
  }

  func animateCloud(_ layer: CALayer) {
    let cloudSpeed = 10.0 / Double(view.frame.size.width)
	let duration: TimeInterval = Double(view.frame.size.width - layer.frame.origin.x) * cloudSpeed

	let cloudMove = CABasicAnimation(keyPath: "position.x")
		cloudMove.duration = duration
		cloudMove.toValue = self.view.bounds.width + layer.bounds.width/2
		cloudMove.delegate = self
		cloudMove.fillMode = kCAFillModeForwards
		cloudMove.isRemovedOnCompletion = false

		cloudMove.setValue("cloud", forKey: "name")
		cloudMove.setValue(layer, forKey: "layer")

	layer.add(cloudMove, forKey: "cloudAnimation")
  }


  // MARK: UITextFieldDelegate

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextField = (textField === username) ? password : username
    nextField?.becomeFirstResponder()
    return true
  }

}

extension ViewController: CAAnimationDelegate {


	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		guard let name = anim.value(forKey: "name") as? String else { return }

		if name == "form" {
			let layer = anim.value(forKey: "layer") as? CALayer
			anim.setValue(nil, forKey: "layer")

			let pulse = CASpringAnimation(keyPath: "transform.scale")
				pulse.damping = 7.5
				pulse.fromValue = 1.25
				pulse.toValue = 1.0
				pulse.duration = pulse.settlingDuration
			layer?.add(pulse, forKey: nil)
		}
		if name == "cloud" {
			guard let layer = anim.value(forKey: "layer") as? CALayer else {return}

			layer.position.x = -layer.bounds.width/2
			layer.removeAllAnimations()

			delay(seconds: 0.5) {
				self.animateCloud(layer)
			}
		}

	}
}

extension ViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		guard let runningAnimations = info.layer.animationKeys() else { return }
		info.layer.removeAnimation(forKey: "infoappear")
	}
	func textFieldDidEndEditing(_ textField: UITextField) {
		guard let text = textField.text else { return }

		if text.count < 5 {
			let jump = CASpringAnimation(keyPath: "position.y")
				jump.fromValue = textField.layer.position.y + 1.0
				jump.toValue = textField.layer.position.y
				jump.initialVelocity = 100.0
				jump.mass = 10.0
				jump.stiffness = 1500.0
				jump.damping = 50.0
				jump.duration = jump.settlingDuration
			textField.layer.add(jump, forKey: nil)

			textField.layer.borderWidth = 3.0
			textField.layer.borderColor = UIColor.clear.cgColor

			let flash = CASpringAnimation(keyPath: "borderColor")
				flash.damping = 7.0
				flash.stiffness = 200.0
				flash.fromValue = UIColor(red: 1.0, green: 0.27, blue: 0.0, alpha: 1.0).cgColor
				flash.toValue = UIColor.white.cgColor
				flash.duration = flash.settlingDuration
			textField.layer.add(flash, forKey: nil)

			textField.layer.cornerRadius = 5
		}
	}
}
