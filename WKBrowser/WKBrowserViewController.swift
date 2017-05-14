//
//  WKBrowserViewController.swift
//  WKBrowser
//
//  Created by dali on 10/04/2017.
//  Copyright © 2017 itdali. All rights reserved.
//

import UIKit
import WebKit

private struct keyPaths {
    /* WKWebView */
    static let estimatedProgress: String = "estimatedProgress"
    static let title: String = "title"
    static let url: String = "url"
    static let isLoading: String = "isLoading"
    static let canGoBack: String = "canGoBack"
    static let canGoForward: String = "canGoForward"
}

class WKBrowserViewController: UIViewController,
    WKNavigationDelegate,
    WKUIDelegate,
    WKScriptMessageHandler,
    UIGestureRecognizerDelegate,
    UIScrollViewDelegate,
    UITextFieldDelegate,
    UINavigationBarDelegate
{
    
    // web view
    private var web: WKWebView!
    private var progressView: UIProgressView!
    private var isBackEnabled: Bool = false
    private var backList: [WKBackForwardListItem] = []
    
    // bookmark view
    fileprivate var websiteMngView: WebsiteManageView!
    private var historyView: HistoryView!
    private var historyDataSource: HistoryDataSource!
    
    
    // Tool bar
    private var toolBar: UIToolbar!
    private var backBarBtn: UIBarButtonItem!
    private var forwardBarBtn: UIBarButtonItem!
    private var shareBarBtn: UIBarButtonItem!
    private var bookmarkBarBtn: UIBarButtonItem!
    private var editBarBtn: UIBarButtonItem!
    
    private var backBtnView: UIView!
    private var forwardBtnView: UIView!
    private var shareBtnView: UIView!
    private var bookmarkBtnView: UIView!
    private var editBtnView: UIView!
    private var editBtnViewTitle: UILabel!
    
    // Navigation Bar
    private var addrBar: UITextField!
    private var addrNavItem: UINavigationItem!
    private var titleBar: UITextField!
    private var titleNavItem: UINavigationItem!
    private var navigationBar: UINavigationBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        

        loadWebView()
        loadWebsiteMngView()
        loadToolBar()
        loadNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(TextFieldTextDidChange), name: .UITextFieldTextDidChange, object: nil)
        
    }
    
    //MARK:- load web view
    private func loadWebView() {
        let config: WKWebViewConfiguration = WKWebViewConfiguration()
        // set preferences
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        config.preferences.minimumFontSize = 10
        // init userContentController
        config.userContentController = WKUserContentController()
        if #available(iOS 10.0, *) {
            // text will be transformed to be link
            config.dataDetectorTypes = [.link, .phoneNumber]
        } else {
            // Fallback on earlier versions
        }
        web = WKWebView(frame: CGRect(x: 0, y: 64, width: Constants.layout.screenWidth, height: Constants.layout.screenHeight-64-49), configuration: config)
        //webOldPoint = web.scrollView.contentOffset
        web.allowsBackForwardNavigationGestures = true
        web.uiDelegate = self
        web.navigationDelegate = self
        web.scrollView.delegate = self
        view.addSubview(web)
        
        // add progress to web
        progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: Constants.layout.screenWidth, height: 2))
        progressView.setProgress(0, animated: false)
        progressView.progressTintColor = UIColor.blue
        progressView.trackTintColor = UIColor.white
        web.addSubview(progressView)
        web.isHidden = true
        
        // add KVO to web
        web.addObserver(self, forKeyPath: keyPaths.estimatedProgress, options: .new, context: nil)
        web.addObserver(self, forKeyPath: keyPaths.title, options: .new, context: nil)
        web.addObserver(self, forKeyPath: keyPaths.url, options: .new, context: nil)
        web.addObserver(self, forKeyPath: keyPaths.isLoading, options: .new, context: nil)
        web.addObserver(self, forKeyPath: keyPaths.canGoBack, options: .new, context: nil)
        web.addObserver(self, forKeyPath: keyPaths.canGoForward, options: .new, context: nil)
        
        /*
         // load page in project
         if let webUrl = Bundle.main.url(forResource: "WKWebView", withExtension: "html") {
         web.load(URLRequest(url: webUrl))
         } else {
         showErrorLinkPage()
         }*/
        
        // load page in localhost - Apache
        let strUrl: String = "https://www.baidu.com"
        //let strUrl: String = "http://localhost/H5/page/WKWebView.html"
        //loadURL(with: strUrl)
    }
    fileprivate func loadURL(with string: String) {
        if let webUrl = URL(string: string){
            web.isHidden = false
            web.load(URLRequest(url: webUrl))
        } else {
            showErrorLinkPage()
        }
    }
    private func search(with string: String) {
        loadURL(with: "https://www.baidu.com/s?wd=\(string)")
    }
    /// show error message when the link is wrong
    private func showErrorLinkPage() {
        MBProgressHUD.showError(Constants.strings.browserErrorLink)
    }
    
    //MARK:- load Bookmark View
    private func loadWebsiteMngView() {
        websiteMngView = WebsiteManageView(frame: web.frame)
        websiteMngView.delegateExtension = self
        view.addSubview(websiteMngView)
        
    }
    
    //MARK:- ==== Tool Bar ====
    private func loadToolBar() {
        toolBar = UIToolbar(frame: CGRect(x: 0, y: Constants.layout.screenHeight-49, width: Constants.layout.screenWidth, height: 49))
        // 下面两个配色可以用于夜间版
        //toolBar.barStyle = .blackTranslucent
        //toolBar.tintColor = UIColor.gray
        toolBar.barStyle = .default
        toolBar.tintColor = Constants.colors.blue
        
        
        // Tool Bar Style - 1
        
        /*
        // each bar button
        backBarBtn = UIBarButtonItem(image: UIImage.init(named: "back"), style: .plain, target: self, action: #selector(backBarClick))
        forwardBarBtn = UIBarButtonItem(image: UIImage.init(named: "forward"), style: .plain, target: self, action: #selector(forwardBarClick))
        shareBarBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareClick))
        bookmarkBarBtn = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(bookmarkBarClick))
        editBarBtn = UIBarButtonItem(image: UIImage.init(named: "edit-static"), style: .plain, target: self, action: #selector(editBarClick))
        */
 
        
        
        
        // Tool Bar Style - 2
        
        let viewRect = CGRect(x: 0, y: 0, width: 49, height: 49)
        
        backBtnView = UIView(frame: viewRect)
        backBtnView.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "backView-disabled"))
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backClick))
        backBtnView.addGestureRecognizer(backTap)
        let backLongPress = UILongPressGestureRecognizer(target: self, action: #selector(backLongPressClick))
        backBtnView.addGestureRecognizer(backLongPress)
        backBarBtn = UIBarButtonItem(customView: backBtnView)
        
        forwardBtnView = UIView(frame: viewRect)
        forwardBtnView.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "forwardView-disabled"))
        let forwardTap = UITapGestureRecognizer(target: self, action: #selector(forwardClick))
        forwardBtnView.addGestureRecognizer(forwardTap)
        let forwardLongPress = UILongPressGestureRecognizer(target: self, action: #selector(forwardLongPressClick))
        forwardBtnView.addGestureRecognizer(forwardLongPress)
        forwardBarBtn = UIBarButtonItem(customView: forwardBtnView)
        
        shareBtnView = UIView(frame: viewRect)
        shareBtnView.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "shareView"))
        let shareTap = UITapGestureRecognizer(target: self, action: #selector(shareClick))
        shareBtnView.addGestureRecognizer(shareTap)
        let shareLongPress = UILongPressGestureRecognizer(target: self, action: #selector(shareLongPressClick))
        shareBtnView.addGestureRecognizer(shareLongPress)
        shareBarBtn = UIBarButtonItem(customView: shareBtnView)
        
        bookmarkBtnView = UIView(frame: viewRect)
        bookmarkBtnView.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "bookmarkView"))
        let bookmarkTap = UITapGestureRecognizer(target: self, action: #selector(bookmarkClick))
        bookmarkBtnView.addGestureRecognizer(bookmarkTap)
        let bookmarkLongPress = UILongPressGestureRecognizer(target: self, action: #selector(bookmarkLongPressClick))
        bookmarkBtnView.addGestureRecognizer(bookmarkLongPress)
        bookmarkBarBtn = UIBarButtonItem(customView: bookmarkBtnView)
        
        
        editBtnView = UIView(frame: viewRect)
        editBtnView.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "editStaticView"))
        let editTap = UITapGestureRecognizer(target: self, action: #selector(editClick))
        editBtnView.addGestureRecognizer(editTap)
        let editLongPress = UILongPressGestureRecognizer(target: self, action: #selector(editLongPressClick))
        editBtnView.addGestureRecognizer(editLongPress)
        
        editBtnViewTitle = UILabel(frame: viewRect)
        editBtnViewTitle.text = "1"
        editBtnViewTitle.font = Constants.fonts.toolBarTitle
        editBtnViewTitle.textAlignment = .center
        editBtnViewTitle.textColor = Constants.colors.toolBarTitle
        //editView.addSubview(editViewTitle)
        editBarBtn = UIBarButtonItem(customView: editBtnView)
        
        
        /*
        backView.backgroundColor = UIColor.orange
        forwardView.backgroundColor = UIColor.green
        shareView.backgroundColor = UIColor.purple
        bookmarkBtnView.backgroundColor = UIColor.blue
        editView.backgroundColor = UIColor.brown
        */
        
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        // backBarBtn, forwardBarBtn, shareBarBtn, bookmarkBarBtn, editBarBtn
        toolBar.setItems([backBarBtn,flexibleSpace,
                          forwardBarBtn,flexibleSpace,
                          shareBarBtn,flexibleSpace,
                          bookmarkBarBtn,flexibleSpace,
                          editBarBtn],
                         animated: true)
        view.addSubview(toolBar)
    }
    
    //MARK: Tool Bar Style - 1
    @objc private func backBarClick() {
        DLfunction()
    }
    @objc private func forwardBarClick() {
        DLfunction()
    }
    @objc private func shareBarClick() {
        DLfunction()
    }
    @objc private func bookmarkBarClick() {
        DLfunction()
    }
    @objc private func editBarClick() {
        DLfunction()
    }

    
    
    //MARK: Tool Bar Style - 2
    @objc private func backClick(_ gesture: UITapGestureRecognizer) {
        DLfunction()
        if web.canGoBack {
            if let backItem = web.backForwardList.backItem {
                DLprint(backItem.url)
                web.goBack()
            }
        }
    }
    @objc private func backLongPressClick(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            DLfunction()
        }
    }
    @objc private func forwardClick(_ gesture: UITapGestureRecognizer) {
        DLfunction()
        if web.canGoForward {
            if let forwardItem = web.backForwardList.forwardItem {
                DLprint(forwardItem.url)
                web.goForward()
            }
        }
    }
    @objc private func forwardLongPressClick(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            DLfunction()
        }
    }
    @objc private func shareClick(_ gesture: UITapGestureRecognizer) {
        DLfunction()
    }
    @objc private func shareLongPressClick(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            DLfunction()
        }
    }
    @objc private func bookmarkClick(_ gesture: UITapGestureRecognizer) {
        DLfunction()
        let websiteManageVC = WebsiteManageController()
        websiteManageVC.delegateExtension = self
        self.present(websiteManageVC, animated: true, completion: {() -> Void in
            DLprint("persent to WebsiteManageController")
        })
    }
    @objc private func bookmarkLongPressClick(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            DLfunction()
        }
    }
    @objc private func editClick(_ gesture: UITapGestureRecognizer) {
        DLfunction()
        web.reload()
    }
    @objc private func editLongPressClick(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            DLfunction()
        }
    }
    @objc private func refreshClick() {
        DLfunction()
        web.reload()
    }
    
    
    //MARK:- load Navigation bar
    private func loadNavigationBar() {
        
        // title bar
        titleBar = UITextField(frame: CGRect(x: 20, y: 0, width: Constants.layout.screenWidth-40, height: 22))
        titleBar.clipsToBounds = true
        titleBar.layer.cornerRadius = 3
        titleBar.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        titleBar.adjustsFontSizeToFitWidth = true
        titleBar.minimumFontSize = 10
        titleBar.isSelected = false
        //titleBar.text = "Title"
        titleBar.placeholder = Constants.strings.titlePlaceholderText
        titleBar.textAlignment = .center
        titleBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 22))
        titleBar.leftViewMode = .always
        titleBar.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 22))
        titleBar.rightViewMode = .always
        titleBar.delegate = self
        titleBar.font = Constants.fonts.textField
        
        // title Nav Item
        titleNavItem = UINavigationItem()
        titleNavItem.titleView = titleBar
        
        // navigation bar
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: Constants.layout.screenWidth, height: 44))
        navigationBar.barTintColor = UIColor.white
        navigationBar.setItems([titleNavItem], animated: true)
        navigationBar.delegate = self
        self.view.addSubview(navigationBar)
        
        
        
        // Address and search bar
        addrBar = UITextField(frame: CGRect(x: 20, y: 0, width: Constants.layout.screenWidth-40, height: 22))
        addrBar.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        addrBar.clipsToBounds = true
        addrBar.layer.cornerRadius = 3
        addrBar.adjustsFontSizeToFitWidth = true
        addrBar.autocapitalizationType = .none
        addrBar.autocorrectionType = .default
        addrBar.minimumFontSize = 10
        addrBar.clearButtonMode = .whileEditing
        addrBar.placeholder = Constants.strings.urlPlaceholderText
        addrBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 22))
        addrBar.leftViewMode = .always
        addrBar.returnKeyType = .go
        addrBar.enablesReturnKeyAutomatically = true
        addrBar.delegate = self
        addrBar.font = Constants.fonts.textField
        // address Nav Item
        addrNavItem = UINavigationItem()
        addrNavItem.titleView = addrBar
        addrNavItem.hidesBackButton = true
        
        
        // cancel btn
        let cancelNavBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelClick))
        addrNavItem.setRightBarButton(cancelNavBtn, animated: true)
    }
    private func goClick() {
        DLfunction()
        
        cancelClick()
        websiteMngView.removeFromSuperview()
        let addrBarText: String = addrBar.text!
        if let url = URL(string: addrBarText){
            if UIApplication.shared.canOpenURL(url) {
                DLprint("can Open URL")
                loadURL(with: addrBarText)
            }
        } else {
            search(with: addrBarText)
            DLprint("can not Open URL")
        }
        
        
    }
    
    @objc private func cancelClick() {
        DLfunction()
        if addrBar.isEditing {
            addrBar.resignFirstResponder()
        }
        _ = navigationBar.popItem(animated: false)
    }
    
    private func showAddrItem() {
        navigationBar.pushItem(addrNavItem, animated: false)
    }
    
    private func hideToolBar() {
        DLfunction()
        var webRect = web.frame
        webRect.size.height += toolBar.frame.height
        var toolBarRect = toolBar.frame
        toolBarRect.origin.y += toolBar.frame.height
        web.frame = webRect
        toolBar.frame = toolBarRect
        DLprint(web.frame)
        DLprint(toolBar.frame)
        /*
        DLprint(web.frame)
        DLprint(toolBar.frame)
        UIView.animate(withDuration: 0.4, animations: { ()-> Void in
            self.web.frame = webRect
            self.toolBar.frame = toolBarRect
            DLprint("")
        })
        DLprint(web.frame)
        DLprint(toolBar.frame)
         */
    }
    private func showToolBar() {
        DLfunction()
        var webRect = web.frame
        webRect.size.height -= toolBar.frame.height
        var toolBarRect = toolBar.frame
        toolBarRect.origin.y -= toolBar.frame.height
        web.frame = webRect
        toolBar.frame = toolBarRect
        DLprint(web.frame)
        DLprint(toolBar.frame)
    }
    
    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        DLprint("decidePolicyFor navigationAction")
        if let url =  navigationAction.request.url{
            DLprint("Action.request.url: \(url.absoluteString)")
            self.titleBar.text = url.absoluteString
        }
        DLprint("navigationType: \(navigationAction.navigationType.hashValue)")
        
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        DLprint("decidePolicyFor navigationResponse")
        if let url = navigationResponse.response.url?.absoluteString {
            DLprint("Response.request.url: \(url)")
        }
        
        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DLprint("didStartProvisionalNavigation")
    }
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        DLprint("didReceiveServerRedirectForProvisionalNavigation")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DLprint("didFailProvisionalNavigation")
        DLprint(error)
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        DLprint("didCommit")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DLprint("didFinish")
        
        if let backItem = webView.backForwardList.backItem {
            DLprint("backItem title: \(String(describing: backItem.title)), url: \(backItem.url)")
        }
        if let currentItem = webView.backForwardList.currentItem {
            if let currentTitle = currentItem.title {
                self.title = currentTitle
                DataBaseManager.update(table: .history, with: currentItem)
            }
            DLprint("currentItem title: \(String(describing: currentItem.title)), url: \(currentItem.url)")
            addrBar.text = currentItem.url.absoluteString
        }
        if let forwardItem = webView.backForwardList.forwardItem {
            DLprint("forwardItem title: \(String(describing: forwardItem.title)), url: \(forwardItem.url)")
        }
        
        /*
         let backList = webView.backForwardList.backList
         print("backList: \(backList)")
         for item in backList {
         print("title: \(item.title), url: \(item.url)")
         }
         
         let forwordList = webView.backForwardList.forwardList
         print("forwordList: \(forwordList)")
         for item in forwordList {
         print("title: \(item.title), url: \(item.url)")
         }*/
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DLprint("didFail")
        DLprint(error)
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        DLprint("didReceive challenge")
        if challenge.previousFailureCount > 0 {
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
        } else if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
        } else {
            DLprint("unknown state. error: \(String(describing: challenge.error))")
            // do something w/ completionHandler here
        }
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        DLprint("webViewWebContentProcessDidTerminate")
    }
    
    
    
    //MARK:- WKUIDelegate
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        DLprint("createWebViewWith configuration")
        return nil
    }
    func webViewDidClose(_ webView: WKWebView) {
        DLprint("webViewDidClose")
    }
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        DLprint("runJavaScriptAlertPanelWithMessage")
        DLprint(message)
        let alert = UIAlertController(title: "alert", message: message, preferredStyle: .alert)
        let confirmBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(confirmBtn)
        self.present(alert, animated: true, completion: nil)
        completionHandler()
        
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        DLprint("runJavaScriptConfirmPanelWithMessage")
        DLprint(message)
        let confirm = UIAlertController(title: "confirm", message: message, preferredStyle: .alert)
        let confirmBtn = UIAlertAction(title: "Confirm", style: .default, handler: {(action) -> Void in
            completionHandler(true)
        })
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) -> Void in
            completionHandler(false)
        })
        confirm.addAction(confirmBtn)
        confirm.addAction(cancelBtn)
        self.present(confirm, animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        DLprint("runJavaScriptTextInputPanelWithPrompt")
        DLprint(prompt)
        DLprint(defaultText)
        let prompt = UIAlertController(title: "prompt", message: prompt, preferredStyle: .alert)
        prompt.addTextField(configurationHandler: {(textField) -> Void in
            DLprint("TextField - configurationHandler")
            textField.placeholder = defaultText
        })
        let confirmBtn = UIAlertAction(title: "Confirm", style: .default, handler: {(action) -> Void in
            completionHandler("")
        })
        prompt.addAction(confirmBtn)
        self.present(prompt, animated: true, completion: nil)
    }
    @available(iOS 10.0, *)
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        DLprint("shouldPreviewElement")
        return true
    }
    @available(iOS 10.0, *)
    func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        DLprint("previewingViewControllerForElement")
        return self
    }
    func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
        DLprint("commitPreviewingViewController")
    }
    
    //MARK:- WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        DLprint("name: \(message.name), body: \(message.body)")
    }
    
    //MARK:- UIScroll View Delegate
    // Dragging
    private var webOldPoint: CGPoint = CGPoint.zero
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        DLprint("scrollViewWillBeginDragging")
        //webOldPoint = scrollView.contentOffset
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DLprint("scrollViewDidScroll - contentOffset: \(scrollView.contentOffset)")
        if addrBar.isEditing {
            addrBar.endEditing(true)
        }
        
        /*
         if webOldPoint.y - scrollView.contentOffset.y >= kScreenHeight*0.2 {
         DLprint("should show tool bar")
         } else {
         DLprint("should hide tool bar")
         if toolBar.frame.minY < kScreenHeight {
         var oldRect = toolBar.frame
         oldRect.origin.y += (webOldPoint.y - scrollView.contentOffset.y - kScreenHeight*0.2)
         toolBar.frame = oldRect
         }
         }*/
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        DLprint("scrollViewWillEndDragging")
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DLprint("scrollViewDidEndDragging")
        webOldPoint = scrollView.contentOffset
    }
    // Zooming
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        DLprint("scrollViewWillBeginZooming")
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        DLprint("scrollViewDidZoom")
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        DLprint("scrollViewDidEndZooming")
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        DLprint("scrollViewShouldScrollToTop")
        return true
    }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        DLprint("scrollViewDidScrollToTop")
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        DLprint("scrollViewWillBeginDecelerating")
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DLprint("scrollViewDidEndDecelerating")
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        DLprint("scrollViewDidEndScrollingAnimation")
    }
    
    
    //MARK:- UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        DLprint("gesture - 1")
        return true
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        DLprint("gesture - 2")
        return true
    }
    @available(iOS 9.0, *)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        DLprint("gesture - 3")
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        DLprint("gesture - 4")
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        DLprint("gesture - 5")
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        DLprint("gesture - 6")
        return true
    }
    
    //MARK:- UIResponder
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DLfunction()
        /*
        let touch = touches.first
        DLprint(touch?.view)
        DLprint(touch?.previousLocation(in: self.view))
        DLprint(touch?.location(in: self.view))
        DLprint(touch?.tapCount)
        DLprint(touch?.timestamp)
         */
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DLfunction()
        /*
        let touch = touches.first
        DLprint(touch?.view)
        DLprint(touch?.previousLocation(in: self.view))
        DLprint(touch?.location(in: self.view))
        DLprint(touch?.tapCount)
        DLprint(touch?.timestamp)
        */
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        DLfunction()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        DLfunction()
    }
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        DLfunction()
    }
    */
    //MARK:- UIText Field Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        DLfunction()
        if textField == titleBar {
            showAddrItem()
            return false
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        DLfunction()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DLfunction()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        DLfunction()
    }
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        DLfunction()
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        DLfunction()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DLfunction()
        goClick()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DLfunction()
        return true
    }
    func TextFieldTextDidChange() {
        DLfunction()
    }
    
    
    //MARK:- Navigation Bar Delegate
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        DLfunction()
        return true
    }
    func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
        DLfunction()
        return true
    }
    func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
        DLfunction()
        DLprint(item)
        DLprint(titleNavItem)
        DLprint(addrNavItem)
        if item == addrNavItem {
            showToolBar()
        }
    }
    func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        DLfunction()
        if item == addrNavItem {
            hideToolBar()
            addrBar.becomeFirstResponder()
        }
    }

    
    // K-V-O
    private var oldProgress: Double = 0
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == keyPaths.estimatedProgress {
            DLprint("estimatedProgress: \(web.estimatedProgress)")
            progressView.setProgress(Float(web.estimatedProgress), animated: (web.estimatedProgress > oldProgress ? true : false))
            progressView.isHidden = web.estimatedProgress == 1
            oldProgress = web.estimatedProgress
        }
        if keyPath == keyPaths.title {
            if let webTitle = web.title {
                DLprint("observeValue - title: \(webTitle)")
                self.title = webTitle
                self.titleBar.text = webTitle
            }
        }
        if keyPath == keyPaths.url {
            if let webUrl = web.url {
                DLprint("observeValue - url: \(webUrl)")
                self.addrBar.text = webUrl.absoluteString
            }
        }
        if keyPath == keyPaths.isLoading {
            DLprint("observeValue - web.isLoading: \(web.isLoading)")
        }
        if keyPath == keyPaths.canGoBack {
            DLprint("observeValue - canGoBack: \(web.canGoBack)")
            backBtnView.backgroundColor = UIColor(patternImage: (web.canGoBack ? #imageLiteral(resourceName: "backView") : #imageLiteral(resourceName: "backView-disabled")))
        }
        if keyPath == keyPaths.canGoForward {
            DLprint("observeValue - canGoForward: \(web.canGoForward)")
            forwardBtnView.backgroundColor = UIColor(patternImage: (web.canGoForward ? #imageLiteral(resourceName: "forwardView") : #imageLiteral(resourceName: "forwardView-disabled")))
        }
    }
    //MARK:- deinit
    deinit {
        DLfunction()
        web.removeObserver(self, forKeyPath: keyPaths.estimatedProgress)
        web.removeObserver(self, forKeyPath: keyPaths.title)
        web.removeObserver(self, forKeyPath: keyPaths.url)
        web.removeObserver(self, forKeyPath: keyPaths.isLoading)
        web.removeObserver(self, forKeyPath: keyPaths.canGoBack)
        web.removeObserver(self, forKeyPath: keyPaths.canGoForward)
        
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WKBrowserViewController: WebsiteManageControllerDelegate {
    func websiteManage(_ websiteManage: UIViewController, openUrlWith string: String) {
        loadURL(with: string)
    }
}

extension WKBrowserViewController: WebsiteManageViewDelegate {
    func WebsiteManageViewOpenUrl(with string: String) {
        websiteMngView.removeFromSuperview()
        loadURL(with: string)
    }
}
