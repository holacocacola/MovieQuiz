import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Структуры
    
    // формат модели главного экрана
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    // формат модели экрана результата
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    // структура вопроса
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    // MARK: - Outlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    
    // MARK: - Properties
    
    //Mock-вопросы квиза
    private let questions: [
        QuizQuestion] = [QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                         QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                         QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                         QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                         QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                         QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                         QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                         QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                         QuizQuestion(image: "Tesla",text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                         QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
        ]
    
    // Индекс текущего вопроса
    private var currentQuestionIndex: Int = 0
    
    // Счетчик правильных ответов
    private var correctAnswersCount: Int = 0
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentQuestion()
    }
    
    
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handleAnswer(false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handleAnswer(true)
    }
    
    
    // MARK: - Приватные функции
    
    //конвертировалка из мокового формата в формат модели главного экрана
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex+1)/\(questions.count)"
        )
        
    }
    
    // Показать квиза на экране
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    // Показать результата с алертом и перезапуском квиза
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswersCount = 0
            let firstQestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action) //добавляем в алерт кнопку
        self.present(alert, animated: true, completion: nil) //показываем всплыв
    }
    
    // Обработка ответа пользователя
    private func handleAnswer(_ givenAnswer: Bool) {
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = currentQuestion.correctAnswer == givenAnswer
        showAnswerResult(isCorrect: isCorrect)
    }
    
    // Визуальная индикация правильности ответа и переход далее
    private func showAnswerResult(isCorrect: Bool) {
        
        // если ответ ок, то увеличиваем эту переменную
        if isCorrect {
            correctAnswersCount += 1
        }
        
        // хуярим обводку, если ответ правильный - зеленым, если нет - красным
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        //волшебство, которое мне пока неподвластно: через секунду снимает обводку и показать следующий вопрос или результат
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) {
            self.resetBorder() //снимаю обводку
            self.showNextQuestionOrResult()
        }
        
    }
    
    // снимаем обводку с постера, а то так-то в курсе об этом забыли
    private func resetBorder() {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
    }
    
    // Переход к следующему вопросу или показ итога
    private func showNextQuestionOrResult() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswersCount)/\(questions.count)"
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewMode = convert(model: nextQuestion)
            show(quiz: viewMode)
        }
    }
    
    // Отрисовать текущий вопрос
    private func showCurrentQuestion() {
        let firstQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: firstQuestion)
        show(quiz: viewModel)
    }
    
    
}
