const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp({
    credential: admin.credential.applicationDefault(),
});

const firestore = admin.firestore();
const FieldValue = require('firebase-admin').firestore.FieldValue;

const XMLHttpRequest = require("xhr2").XMLHttpRequest;

const runtimeOptions = {
    timeoutSeconds: 512,
}

firestore.settings({ ignoreUndefinedProperties: true });

exports.extractBrands = functions.runWith(runtimeOptions).https.onRequest((req, res) => {

    var numberOfPage = req.query.numberOfPage;

    if (numberOfPage == null) {
        numberOfPage = 1;
    }

    var allCategories = 'https://geeksempire.co/wp-json/wc/v3/products/categories?consumer_key=ck_e469d717bd778da4fb9ec24881ee589d9b202662&consumer_secret=cs_ac53c1b36d1a85e36a362855d83af93f0d377686'
        + '&page=' + numberOfPage
        + '&per_page=100';

    var xmlHttpRequest = new XMLHttpRequest();
    xmlHttpRequest.open('GET', allCategories, true);
    xmlHttpRequest.setRequestHeader('accept', 'application/json');
    xmlHttpRequest.setRequestHeader('Content-Type', 'application/json');
    xmlHttpRequest.onload = function () {

        var jsonArrayParserResponse = JSON.parse(xmlHttpRequest.responseText);
        console.log(jsonArrayParserResponse);

    };
    xmlHttpRequest.send();

});