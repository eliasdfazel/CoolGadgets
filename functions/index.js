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

/*
 * START - Extract Brands
 */
var pageIndex = 1;

exports.extractBrands = functions.runWith(runtimeOptions).https.onRequest((req, res) => {

    retrieveBrands(pageIndex);

});

async function retrieveBrands(numberOfPage) {

    var allCategories = 'https://geeksempire.co/wp-json/wc/v3/products/categories?consumer_key=ck_e469d717bd778da4fb9ec24881ee589d9b202662&consumer_secret=cs_ac53c1b36d1a85e36a362855d83af93f0d377686'
    + '&page=' + numberOfPage
    + '&per_page=100';

    var xmlHttpRequest = new XMLHttpRequest();
    xmlHttpRequest.open('GET', allCategories, true);
    xmlHttpRequest.setRequestHeader('accept', 'application/json');
    xmlHttpRequest.setRequestHeader('Content-Type', 'application/json');
    xmlHttpRequest.onload = function () {

        var jsonArrayParserResponse = JSON.parse(xmlHttpRequest.responseText);
        
        if (jsonArrayParserResponse.length > 0) {

            pageIndex = pageIndex + 1;

            retrieveBrands(pageIndex);

            jsonArrayParserResponse.forEach((jsonObject) => {

                setupBands(jsonObject);
    
            });

        }

    };
    xmlHttpRequest.send();

}

function setupBands(jsonObject) {

    const categoryId = jsonObject['id'].toString();
    const parentId = jsonObject['parent'].toString();

    const categoryName = jsonObject['name'].toString();
    const categoryDescription = jsonObject['description'].toString();

    if (parentId == '6004' && jsonObject['image'] != null) {
        
        const categoryImage = jsonObject['image']['src'].toString();

        var firestoreDirectory = '/' + 'CoolGadgets'
            + '/' + 'Products'
            + '/' + 'Brands'
            + '/' + categoryName;

        firestore.doc(firestoreDirectory).set({
            categoryId: categoryId,
            categoryName: categoryName,
            categoryDescription: categoryDescription,
            categoryImage: categoryImage
        }).then(result => { }).catch(error => { functions.logger.log(error); });

    }

}
/*
 * END - Extract Brands
 */