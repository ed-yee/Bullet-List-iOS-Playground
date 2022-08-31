//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

struct TabOptions {
    var alignment: NSTextAlignment
    var location: CGFloat
}

class MyViewController : UIViewController {
    var sampleData: [String] = [
        "This is list item 1. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vitae.",
        "This is list item 2. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vitae.",
        "This is list item 3. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vitae.",
        "This is list item 4. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vitae.",
    ]

    /// Convert number to Roman numerals
    ///
    /// Source:
    /// Convert numbers to Roman Numerials in Swift, by Eric Callanan
    /// https://swdevnotes.com/swift/2021/convert-numbers-to-roman-numerials-in-swift/
    ///
    /// - Parameter n: Source number
    /// - Returns: Roman numerals
    func romanNumeralFor(_ n:Int) -> String {
        guard n > 0 && n < 4000 else {
            return "Number must be between 1 and 3999"
        }
        
        var returnString = ""
        let arabicNumbers = [1000,  900, 500,  400, 100,   90,  50,   40,  10,    9,   5,    4,  1]
        let romanLetters  = [ "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        
        var num = n
        for (ar, rome) in zip(arabicNumbers, romanLetters) {
            let repeats = num / ar
            returnString += String(repeating: rome, count: repeats)
            num = num % ar
        }
        return returnString
    }
    
    /// Add subviews
    /// - Parameters:
    ///   - contents: Array of UIViews
    ///   - contentView: Container UIView
    func addContents(_ contents: [UIView], _ contentView: UIView) {
        for (idx, content) in contents.enumerated() {
            // Add UILabel to the content-view
            contentView.addSubview(content)
            
            // Setup UILabel constraints w.r.t. the view
            var constraints: [NSLayoutConstraint] = []
            
            var topAnchor: NSLayoutConstraint
            if (idx == 0) {
                // For the first UILabel, the top anchor is set against the top anchor of the content-view
                topAnchor = content.topAnchor.constraint(
                    equalToSystemSpacingBelow: contentView.topAnchor,
                    multiplier: 2
                )
            } else {
                // For the remaining UILabel, the top anchor is set against the bottom of the previous UILabel
                topAnchor = content.topAnchor.constraint(
                    equalToSystemSpacingBelow: contents[idx-1].bottomAnchor,
                    multiplier: 2
                )
            }
            
            // Set the leading and trailing anchor constraints w.r.t. the content-view
            constraints.append(contentsOf: [
                topAnchor,
                content.leadingAnchor.constraint(
                    equalToSystemSpacingAfter: contentView.leadingAnchor,
                    multiplier: 2),
                contentView.trailingAnchor.constraint(
                    equalToSystemSpacingAfter: content.trailingAnchor,
                    multiplier: 2)
            ])
            
            // Activate the constraints
            NSLayoutConstraint.activate(constraints)
        }
        
        // Set the content-view bottom anchor to the last control
        if let lastCtrl = contents.last {
            NSLayoutConstraint.activate([
                contentView.bottomAnchor.constraint(
                    equalToSystemSpacingBelow: lastCtrl.bottomAnchor,
                    multiplier: 2)
            ])
        }
    }

    /// Get UIView list container
    /// - Returns: An instance of UIView
    func getListContainer() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // Add border for presentation purposes
        container.layer.borderColor = UIColor.black.cgColor
        container.layer.borderWidth = 1.0
        
        return container
    }
    
    /// Get UIStackView list container
    /// - Parameters:
    ///   - padding: Container padding space. Default value is 16.0 points
    ///   - itemSpacing: List item spacing. Default value is 16.0 points
    /// - Returns: An instance of UIStackView
    func getListStackContainer(padding: CGFloat = 16.0,
                               itemSpacing: CGFloat = 16.0) -> UIStackView {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        
        // Add border for presentation purposes
        container.layer.borderColor = UIColor.black.cgColor
        container.layer.borderWidth = 1.0
        
        // Spacing between list item
        container.spacing = itemSpacing
        
        // Add container padding
        container.layoutMargins = UIEdgeInsets(top: padding,
                                               left: padding,
                                               bottom: padding,
                                               right: padding)
        container.isLayoutMarginsRelativeArrangement = true
        
        return container
    }
    
    /// Get label. Set content to the text property
    /// - Parameter content: List item caption
    /// - Returns: An instance of UILabel
    func getLabel(content: String) -> UILabel {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = content
        return lbl
    }
    
    /// Get label. Set content to the attributedTitle
    /// - Parameters:
    ///   - content: List item caption
    ///   - indentation: List item caption left-margin value. Default value 25.0 points
    ///   - tabs: Custom tab-stops. Default is NIL
    /// - Returns: An instance of UILabel
    func getAttributedLabel(content: String,
                            indentation: CGFloat = 25,
                            tabs: [TabOptions]? = nil) -> UILabel {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        // Default tab-stop
        var tabStops = [NSTextTab(textAlignment: .left,
                                  location: indentation)]
        if let tabs = tabs {
            // Override default
            tabStops = tabs.map({ tabOpt in
                return NSTextTab(textAlignment: tabOpt.alignment,
                                 location: tabOpt.location)
            })
        }
        
        // Hanging paragraph style
        let hangingIndent = NSMutableParagraphStyle()
        hangingIndent.headIndent = indentation
        hangingIndent.firstLineHeadIndent = -indentation
        hangingIndent.tabStops = tabStops
        
        // Create attributed string with hanging paragraph style
        lbl.attributedText = NSAttributedString(string: content,
                                                attributes: [
                                                    .paragraphStyle: hangingIndent
                                                ])

        return lbl
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view

        // Add scroll-view to the view
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Set scroll-view constraints against main view's safe-area layout guide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        // Add a content view to the scroll-view
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Set content view layout guide againt scroll-view's content layout guide
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            // Set content view width equal to the main view width
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        // Add contents
        let contents = [
            getLabel(content: "Simple list"),
            simpleList(),
            getLabel(content: "Simple bullet list"),
            simpleBulletList(),
            getLabel(content: "Happy face bullet list"),
            simpleBulletList(leadIcon: "😀"),
            getLabel(content: "Properly aligned bullet list"),
            alignedBulletList(),
            getLabel(content: "Happy faces bullet list with different indentation"),
            alignedBulletList(leadIcon: "😀😀", indentation: 60),
            getLabel(content: "Numeric ordered list"),
            numericList(),
            getLabel(content: "Numeric ordered list with prefix"),
            numericList(prefix: "A.", indentation: 40),
            getLabel(content: "Roman numeral ordered list"),
            romanNumeralList(indentation: 40),
            getLabel(content: "Right align lead number ordered list"),
            rightAlignRomanNumeralList(),
            getLabel(content: "Use UIStackView as container - smaller padding and list item spacing"),
            useStackViewContainer(),
        ]
        
        addContents(contents, contentView)

    }
    
    func simpleList() -> UIView {
        let list = getListContainer()

        let contents: [UIView] = sampleData.map { dataString in
            getLabel(content: dataString)
        }
        
        addContents(contents, list)

        return list
    }
    
    func simpleBulletList() -> UIView {
        let list = getListContainer()

        let contents: [UIView] = sampleData.enumerated().map { (idx, dataString) in
            getLabel(content: String(format: "•\t%@", dataString))
        }
        
        addContents(contents, list)
        
        return list
    }
    
    func simpleBulletList(leadIcon: String = "•") -> UIView {
        let list = getListContainer()
        let contents: [UIView] = sampleData.enumerated().map { (idx, dataString) in
            getLabel(content: String(format: "%@\t%@", leadIcon, dataString))
        }
        
        addContents(contents, list)
        
        return list
    }
    
    func alignedBulletList(leadIcon: String = "•",
                           indentation: CGFloat = 25.0) -> UIView {
        let list = getListContainer()

        let contents: [UIView] = sampleData.map { dataString in
            getAttributedLabel(content: String(format: "%@\t%@", leadIcon, dataString),
                               indentation: indentation)
        }
        
        addContents(contents, list)
        
        return list
    }
    
    func numericList(prefix: String = "",
                     indentation: CGFloat = 25.0) -> UIView {
        let list = getListContainer()

        let contents: [UIView] = sampleData.enumerated().map { (idx, dataString) in
            getAttributedLabel(content: String(format: "%@%d.\t%@", prefix, (idx+1), dataString),
                               indentation: indentation)
        }
        
        addContents(contents, list)
        
        return list
    }
    
    func romanNumeralList(indentation: CGFloat = 25.0) -> UIView {
        let list = getListContainer()

        let contents: [UIView] = sampleData.enumerated().map { (idx, dataString) in
            getAttributedLabel(content: String(format: "%@.\t%@", romanNumeralFor(idx+1), dataString),
                               indentation: indentation)
        }
        
        addContents(contents, list)
        
        return list
    }
    
    func rightAlignRomanNumeralList() -> UIView {
        let list = getListContainer()

        let indentation: CGFloat = 40.0
        let contents: [UIView] = sampleData.enumerated().map { (idx, dataString) in
            getAttributedLabel(content: String(format: "\t%@.\t%@", romanNumeralFor(idx+1), dataString),
                               indentation: indentation,
                               tabs: [TabOptions(alignment: .right, location: indentation - 10),
                                      TabOptions(alignment: .left, location: indentation)
                                     ])
        }

        addContents(contents, list)

        return list
    }
    
    func useStackViewContainer() -> UIView {
        let indentation: CGFloat = 40.0
        let list = getListStackContainer(padding: 8, itemSpacing: 3)

        sampleData.enumerated().forEach { (idx, dataString) in
            list.addArrangedSubview(getAttributedLabel(
                content: String(format: "\t%@.\t%@", romanNumeralFor(idx+1), dataString),
                indentation: indentation,
                tabs: [TabOptions(alignment: .right, location: indentation - 10),
                       TabOptions(alignment: .left, location: indentation)
                      ]))
        }
        
        return list
    }

}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
