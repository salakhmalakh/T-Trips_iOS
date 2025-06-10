import UIKit
import Combine

final class EditProfileViewController: UIViewController {
    private let editView = EditProfileView()
    private let viewModel: EditProfileViewModel
    private var cancellables = Set<AnyCancellable>()

    init() {
        guard let user = NetworkAPIService.shared.currentUser else {
            fatalError("No logged user")
        }
        self.viewModel = EditProfileViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        guard let user = NetworkAPIService.shared.currentUser else { return nil }
        self.viewModel = EditProfileViewModel(user: user)
        super.init(coder: coder)
    }

    override func loadView() {
        view = editView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "editData".localized
        setupBindings()
        setupActions()
    }

    private func setupBindings() {
        editView.firstNameTextField.text = viewModel.firstName
        editView.lastNameTextField.text = viewModel.lastName
        editView.phoneTextField.text = viewModel.phone

        viewModel.$isSaveEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] enabled in
                self?.editView.saveButton.isEnabled = enabled
            }
            .store(in: &cancellables)
    }

    private func setupActions() {
        editView.firstNameTextField.addAction(UIAction { [weak self] _ in
            self?.viewModel.firstName = self?.editView.firstNameTextField.text ?? ""
        }, for: .editingChanged)
        editView.lastNameTextField.addAction(UIAction { [weak self] _ in
            self?.viewModel.lastName = self?.editView.lastNameTextField.text ?? ""
        }, for: .editingChanged)
        editView.phoneTextField.addAction(UIAction { [weak self] _ in
            self?.viewModel.phone = self?.editView.phoneTextField.text ?? ""
        }, for: .editingChanged)

        editView.saveButton.addAction(UIAction { [weak self] _ in
            self?.viewModel.save()
        }, for: .touchUpInside)

        viewModel.onSaved = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
