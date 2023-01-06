import UIKit
import CoreLocation

class MasterVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBtn: UIButton!
    var currentLocationForecast: ForecastModelElement?
    var currentCityName: String?
    var viewModel = MasterViewModel()
    var navController: UINavigationController?
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLocationAndForecast()
        setupViewController()
    }
    @IBAction func searchBtnAction(_ sender: Any) {
        coordinator?.pushToSearchView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Setup ViewController
    private func setupViewController() {
        self.coordinator = Coordinator.init(viewController: self)
        viewModel.vc = self
        viewModel.delegate = self
        self.setUpTableView()
    }
    
    // MARK: View Setup
    fileprivate func registerCells() {
        tableView.register(UINib(nibName: Cell.className, bundle: nil), forCellReuseIdentifier: Cell.className)
    }
    
    private func setUpTableView() {
        self.registerCells()
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }
    
    func getLocationAndForecast(){
        if LocationManager.isLocationAvailable && LocationManager.sharedInstance.lastLocation != nil {
            if let latitude = LocationManager.sharedInstance.lastLocation?.coordinate.latitude, let longitude = LocationManager.sharedInstance.lastLocation?.coordinate.longitude{
                print(latitude,longitude)
                SharedManager.sharedInstance.getForecastOfCurrentLocation(latLong: "\(latitude),\(longitude)", completionHandler: { (forecast: ForecastModelElement?) in
                    self.currentLocationForecast = forecast
                    self.reloadTable()
                })
            }else{
                SharedManager.sharedInstance.getForecastOfCurrentLocation(latLong: Constants.fallbackLatLong, completionHandler: { (forecast: ForecastModelElement?) in
                    self.currentLocationForecast = forecast
                    self.reloadTable()
                })
            }
        } else {
            DispatchQueue.main.async {
                LocationManager.sharedInstance.getLocation {(location: CLLocation?, error: NSError?) in
                    if error == nil {
                        // location is available
                        if let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude{
                            print(latitude,longitude)
                            SharedManager.sharedInstance.getForecastOfCurrentLocation(latLong: "\(latitude),\(longitude)", completionHandler: { (forecast: ForecastModelElement?) in
                                self.currentLocationForecast = forecast
                                self.reloadTable()
                            })
                        }else{
                            SharedManager.sharedInstance.getForecastOfCurrentLocation(latLong: Constants.fallbackLatLong, completionHandler: { (forecast: ForecastModelElement?) in
                                self.currentLocationForecast = forecast
                                self.reloadTable()
                            })
                        }
                        
                    } else {
                        // location permission is denied
                        SharedManager.sharedInstance.getForecastOfCurrentLocation(latLong: Constants.fallbackLatLong, completionHandler: { (forecast: ForecastModelElement?) in
                            self.currentLocationForecast = forecast
                            self.reloadTable()
                        })
                    }
                }
            }
        }
    }
}

extension MasterVC: MasterViewDelegate {
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
