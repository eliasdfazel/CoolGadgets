const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp({
    credential: admin.credential.applicationDefault(),
});

const firestore = admin.firestore();
const FieldValue = require('firebase-admin').firestore.FieldValue;

const XMLHttpRequest = require("xhr2").XMLHttpRequest;

const palette = require('image-palette');
const pixels = require('image-pixels');

const runtimeOptions = {
    timeoutSeconds: 512,
}

firestore.settings({ ignoreUndefinedProperties: true });

/*
 * START - Extract Brands
 */
var pageIndexBrands = 1;

exports.extractBrands = functions.runWith(runtimeOptions).https.onRequest((req, res) => {

    retrieveBrands(pageIndexBrands);

});

async function retrieveBrands(numberOfPage) {

    var allCategories = 'https://geeksempire.co/wp-json/wc/v3/products/categories?consumer_key=ck_e469d717bd778da4fb9ec24881ee589d9b202662&consumer_secret=cs_ac53c1b36d1a85e36a362855d83af93f0d377686'
    + '&page=' + numberOfPage
    + '&per_page=100'
    + '&orderby=count&order=desc';

    var xmlHttpRequest = new XMLHttpRequest();
    xmlHttpRequest.open('GET', allCategories, true);
    xmlHttpRequest.setRequestHeader('accept', 'application/json');
    xmlHttpRequest.setRequestHeader('Content-Type', 'application/json');
    xmlHttpRequest.onload = function () {

        var jsonArrayParserResponse = JSON.parse(xmlHttpRequest.responseText);
        
        if (jsonArrayParserResponse.length > 0) {

            pageIndexBrands = pageIndexBrands + 1;

            retrieveBrands(pageIndexBrands);

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

    const categoryIndex = jsonObject['count'].toString();

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
            categoryImage: categoryImage,
            categoryIndex: categoryIndex
        }).then(result => { }).catch(error => { functions.logger.log(error); });

    }

}
/*
 * END - Extract Brands
 */

/*
 * START - Extract Cool Gadgets Subcategory
 */
var pageIndexCoolGadgets = 1;

exports.extractCoolGadgets = functions.runWith(runtimeOptions).https.onRequest((req, res) => {

    retrieveCoolGadgets(pageIndexCoolGadgets);

});

async function retrieveCoolGadgets(numberOfPage) {

    var allCategories = 'https://geeksempire.co/wp-json/wc/v3/products/categories?consumer_key=ck_e469d717bd778da4fb9ec24881ee589d9b202662&consumer_secret=cs_ac53c1b36d1a85e36a362855d83af93f0d377686'
        + '&page=' + numberOfPage
        + '&per_page=100'
        + '&orderby=count&order=desc';

    var xmlHttpRequest = new XMLHttpRequest();
    xmlHttpRequest.open('GET', allCategories, true);
    xmlHttpRequest.setRequestHeader('accept', 'application/json');
    xmlHttpRequest.setRequestHeader('Content-Type', 'application/json');
    xmlHttpRequest.onload = function () {

        var jsonArrayParserResponse = JSON.parse(xmlHttpRequest.responseText);
        
        if (jsonArrayParserResponse.length > 0) {

            pageIndexCoolGadgets = pageIndexCoolGadgets + 1;

            retrieveCoolGadgets(pageIndexCoolGadgets);

            jsonArrayParserResponse.forEach((jsonObject) => {

                setupCoolGadgets(jsonObject);
    
            });

        }

    };
    xmlHttpRequest.send();

}

async function setupCoolGadgets(jsonObject) {

    const categoryId = jsonObject['id'].toString();
    const parentId = jsonObject['parent'].toString();

    const categoryName = jsonObject['name'].toString();
    const categoryDescription = jsonObject['description'].toString();

    const categoryIndex = jsonObject['count'].toString();

    if (parentId == '5563' && jsonObject['image'] != null) {
        
        const categoryImage = jsonObject['image']['src'].toString();

        const dominantColor = await extractPalette(categoryImage);

        var firestoreDirectory = '/' + 'CoolGadgets'
            + '/' + 'Products'
            + '/' + 'Categories'
            + '/' + categoryName;

        firestore.doc(firestoreDirectory).set({
            categoryId: categoryId,
            categoryName: categoryName,
            categoryDescription: categoryDescription,
            categoryImage: categoryImage,
            categoryColor: dominantColor.toString(),
            categoryIndex: categoryIndex
        }).then(result => { }).catch(error => { functions.logger.log(error); });

    }

}

async function extractPalette(imageLink) {

    var {ids, colors} = palette(await pixels(imageLink));

    return colors[0];
}
/*
 * END - Extract Cool Gadgets Subcategory
 */

/*
 * START - Extract Magazine 
 */
exports.extractMagazine = functions.runWith(runtimeOptions).https.onRequest((req, res) => {

    retrieveMagazine();

});

async function retrieveMagazine() {

    var allMagazine = 'https://geeksempire.co/wp-json/wp/v2/posts?tags=5884,7136&per_page=100&page=1';

    var xmlHttpRequest = new XMLHttpRequest();
    xmlHttpRequest.open('GET', allMagazine, true);
    xmlHttpRequest.setRequestHeader('Authorization', 'Basic Z2Vla3NlbXBpcmVpbmM6KmdYZW1waXJlIzEwMjk2JA==');
    xmlHttpRequest.setRequestHeader('accept', 'application/json');
    xmlHttpRequest.setRequestHeader('Content-Type', 'application/json');
    xmlHttpRequest.onload = function () {

        var jsonArrayParserResponse = JSON.parse(xmlHttpRequest.responseText);
        
        if (jsonArrayParserResponse.length > 0) {

            jsonArrayParserResponse.forEach((jsonObject) => {

                prepapreMagazine(jsonObject);
    
            });

        }

    };
    xmlHttpRequest.send();


}

async function prepapreMagazine(jsonObject) {

    const magazineId = jsonObject['id'].toString();

    const magazineTitle = jsonObject['title'].rendered.toString();
    const magazineImageId = jsonObject['featured_media'].toString();

    var magazineImageEndpoint = 'https://geeksempire.co/wp-json/wp/v2/media/' + magazineImageId;

    var xmlHttpRequest = new XMLHttpRequest();
    xmlHttpRequest.open('GET', magazineImageEndpoint, true);
    xmlHttpRequest.setRequestHeader('Authorization', 'Basic Z2Vla3NlbXBpcmVpbmM6KmdYZW1waXJlIzEwMjk2JA==');
    xmlHttpRequest.setRequestHeader('accept', 'application/json');
    xmlHttpRequest.setRequestHeader('Content-Type', 'application/json');
    xmlHttpRequest.onload = function () {

        var jsonArrayParserResponse = JSON.parse(xmlHttpRequest.responseText);
 
        const magazineImage = jsonArrayParserResponse['guid']['rendered'];

        setupMagazine(magazineId, magazineTitle, magazineImage);

    };
    xmlHttpRequest.send();

}

async function setupMagazine(magazineId, magazineTitle, magazineImage) {

    var firestoreDirectory = '/' + 'CoolGadgets'
        + '/' + 'Magazine'
        + '/' + 'Articles'
        + '/' + magazineId;

    firestore.doc(firestoreDirectory).set({
        magazineId: magazineId,
        magazineTitle: magazineTitle,
        magazineImage: magazineImage
    }).then(result => { }).catch(error => { functions.logger.log(error); });

}
/*
 * END - Extract Magazine 
 */

exports.experiment = functions.runWith(runtimeOptions).https.onRequest((req, res) => {

    

});