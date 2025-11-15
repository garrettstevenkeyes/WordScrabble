//
//  ContentView.swift
//  WordScrabble
//
//  Created by Garrett Keyes on 11/15/25.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var userScore = 0
    
    var body: some View {
        NavigationStack {
            Spacer()
            List {
                Section {
                    TextField("enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New Game") {
                        
                        startGame()
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit {
                addNewWord()
            }
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError){ } message: {
                Text(errorMessage)
            }
        }
        VStack{
            Text("Score: \(userScore)")
                .font(.largeTitle)
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard (answer.count > 3) && (answer != rootWord ) else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "use a different workd!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "Try again! that cant be spelled from \(rootWord)")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "word not recognized", message: "Think of a real word!")
            return
        }
        
        //extra validation
        withAnimation {
            usedWords.insert(answer, at: 0)
            newWord = ""
            userScore += answer.count
        }
    }
    
    func startGame() {
        // reset user score to 0 on start and clear words
        userScore = 0
        usedWords.removeAll()
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        // if we get here could not load throw error
        fatalError("Failed loading start.txt from bundle.")
    }
    
    func isOriginal(word:String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title:String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
