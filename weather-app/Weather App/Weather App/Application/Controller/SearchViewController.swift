import UIKit

class SearchViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var coordinator: Coordinator?
    var viewModel = SearchViewModel()
    var searchCities: [GeoPositionSearchModel]?
    var persistSearchCities: [GeoPositionSearchModel]?
    var currentLocationForecast: ForecastModelElement?
    var currentCityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        self.navigationController?.navigationBar.isHidden = false
        setupViewController()
    }
    // MARK: - Setup ViewController
    private func setupViewController() {
        self.coordinator = Coordinator.init(viewController: self)
        viewModel.vc = self
        viewModel.delegate = self
        self.setUpTableView()
        self.viewModel.cityMap = self.viewModel.userDefaults.dictionary(forKey: Constants.searchStorageKey) ?? [:]
    }
    
    // MARK: View Setup
    fileprivate func registerCells() {
        tableView.register(UINib(nibName: SearchBarTableViewCell.className, bundle: nil), forCellReuseIdentifier: SearchBarTableViewCell.className)
        tableView.register(UINib(nibName: CityTableViewCell.className, bundle: nil), forCellReuseIdentifier: CityTableViewCell.className)
    }
    
    private func setUpTableView() {
        self.registerCells()
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }
    
}
extension SearchViewController: SearchViewDelegate {
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func reloadSectionTable(section: Int) {
        DispatchQueue.main.async {
            self.tableView.reloadSections([section], with: .none)
        }
    }
}
