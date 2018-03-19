extension UILabel {
    public var link: UILabelBindings {
        return UILabelBindings(label: self)
    }
}

public struct UILabelBindings {
    private weak var label: UILabel?
    
    init(label: UILabel?) {
        self.label = label
    }
    
    public var text: Observer<String> {
        return Observer { value in
            self.label?.text = value
        }
    }
    
    public var textColor: Observer<UIColor> {
        return Observer { value in
            self.label?.textColor = value
        }
    }
    
    public var isHidden: Observer<Bool> {
        return Observer { value in
            self.label?.isHidden = value
        }
    }
}
