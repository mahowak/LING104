/// Place your items here. Follow the naming convention: 'words-CONDITIONLABEL'.

var items = [

/// You may edit the text in quotes here to configure the instructions for your experiment

["intro", "Message", {consentRequired: false,
                html: ["div",
                        ["p", "Welcome to the experiment!"],
                        ["p", "For every item you see, decide if it is a word or not a word."],
                        ["p", "Press 'S' if it IS a word, press 'K' if it is NOT a word."],
                        ["p", "Respond as quickly and accurately as you can."]
                      ]}],

["sep", "Separator", {}],


/// Your stimuli go below here.
    ["practice", "OnlineJudgment", { s: "NOW" }],
    ["practice", "OnlineJudgment", { s: "XUSIO" }],
    ["practice", "OnlineJudgment", { s: "EXAM" }],
["wordsYES","OnlineJudgment",{s: "CAT"}],
["wordsYES","OnlineJudgment",{s: "MOTION"}],
["wordsYES","OnlineJudgment",{s: "TWINE"}],
    ["wordsYES", "OnlineJudgment", { s: "KHAKI" }],
    ["wordsYES", "OnlineJudgment", { s: "RADIO" }],
    ["wordsYES", "OnlineJudgment", { s: "LINGUISTICS" }],
    ["wordsYES", "OnlineJudgment", { s: "INEBRIATED" }],
    ["wordsYES", "OnlineJudgment", { s: "LOOK" }],
    ["wordsYES", "OnlineJudgment", { s: "GO" }],
    ["wordsYES", "OnlineJudgment", { s: "SEE" }],
    ["wordsYES", "OnlineJudgment", { s: "PHONETICS" }],
    ["wordsYES", "OnlineJudgment", { s: "GAUCHO" }],
["wordsNO","OnlineJudgment",{s: "ENCYLOPERIO"}],
["wordsNO","OnlineJudgment",{s: "EIUOXIE"}],
["wordsNO","OnlineJudgment",{s: "XXIS"}],
    ["wordsNO", "OnlineJudgment", { s: "FLOPRO" }],
    ["wordsNO", "OnlineJudgment", { s: "QZXIBAR" }],
    ["wordsNO", "OnlineJudgment", { s: "MISUNDERFLORMENT" }],
    ["wordsNO", "OnlineJudgment", { s: "IMPERSCIDIOUS" }],
    ["wordsNO", "OnlineJudgment", { s: "WORDLOOK" }],
    ["wordsNO", "OnlineJudgment", { s: "SPERSHY" }],
    ["wordsNO", "OnlineJudgment", { s: "ALLOP" }],
    ["wordsNO", "OnlineJudgment", { s: "QQZEI" }],
    ["wordsNO", "OnlineJudgment", { s: "BRIPPER" }],


["end", "Message", {transfer: 2000,
                html: ["div",
                        ["p", "All done! Please wait while we send the results to the server."]
                      ]}],

];


/// Edit below here at your own peril

var shuffleSequence = seq("intro", "practice", sepWith("sep", rshuffle(startsWith("words"))), "end");
var practiceItemTypes = ["practice"];
var showProgressBar = false;

var defaults = [
    "Separator", {
        transfer: 1000,
        normalMessage: "",
        errorMessage: "Wrong. Please wait for the next trial.",
        ignoreFailure: true
    },
    "OnlineJudgment", {
        mode: "lexical decision",
        display: "in place",
        SOA: 1000,
        fixationCross: "+"
    }
];