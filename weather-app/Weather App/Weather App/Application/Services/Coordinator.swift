import UIKit

class Coordinator: NSObject {
    var viewController: UIViewController
    var navigationController: UINavigationController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        self.navigationController = viewController.navigationController ?? UINavigationController()
    }
    
    func start() {
        
    }
    
    // MARK: - Navigation Method
    func backNavigation(animation: Bool)  {
        viewController.navigationController?.popViewController(animated: animation)
    }
    
    func backToRootNavigation(animation: Bool) {
        viewController.navigationController?.popToRootViewController(animated: animation)
    }
    
    func pushToWeatherDetail(forecastModel: ForecastModelElement?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: DetailViewController.className) as! DetailViewController
        vc.forecastModel = forecastModel
        self.navigationController.pushViewController(vc, animated: true)
    }
    func pushToSearchView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: SearchViewController.className) as! SearchViewController
        self.navigationController.pushViewController(vc, animated: true)
    }
}
