import ballerina/log;
import ballerinax/mysql;
import ballerina/http;
import ballerina/sql;

configurable string host = ?;
configurable string username = ?;
configurable string password = ?;
configurable string db = ?;
configurable int port = ?;

type Catalog record {
    int id;
    string title;
    string description?;
    string includes;
    string intended?;
    string color;
    string material;
    float price;
};

type Cart record {
    int id;
    string userId;
    int catalogId;
    string quantity;
    string cardDetails?;
    boolean checkedOut;
};

service / on new http:Listener(9090) {
    private mysql:Client mySqlClient;
    function init() returns error? {
        self.mySqlClient = check new (host, username, password, db, port, connectionPool = {maxOpenConnections: 3});
    }

    resource function post addCatalog(@http:Payload Catalog catalogInfo) returns json|error {
        // if catalogInfo.title == "" || catalogInfo.description != "" || catalogInfo.includes == "" || catalogInfo.intended == "" || catalogInfo.color == "" || catalogInfo.material == "" || catalogInfo.price.toString() == "" {
        //     return {"Message": "Insertion failed! title, description, includes, intended, color, material, price fileds are required!"};
        // }

        sql:ParameterizedQuery query = `INSERT INTO catalog (title, description, includes, intended, color, material, price) 
        VALUES (${catalogInfo.title}, ${catalogInfo.description}, ${catalogInfo.includes}, ${catalogInfo.intended}, ${catalogInfo.color}, ${catalogInfo.material}, ${catalogInfo.price})`;

        sql:ExecutionResult catalogResult = check self.mySqlClient->execute(query);

        if catalogResult.affectedRowCount != 0 {
            log:printInfo("InsertedId: ", InsertedId = catalogResult.lastInsertId.toString());
            return {"InsertedId: ": catalogResult.lastInsertId.toString()};
        } else {
            log:printError("Error while inserting data to cart: ", cartResult = catalogResult);
            return error("Error while inserting data to cart");
        }
    }

    resource function post updateCatalog(@http:Payload Catalog catalogInfo) returns json|error {
        // if catalogInfo.id.toString() === "" || catalogInfo.title === "" || catalogInfo.description != "" || catalogInfo.includes == "" || catalogInfo.intended == "" || catalogInfo.color == "" || catalogInfo.material == "" || catalogInfo.price.toString() == "" {
        //     return {"Message": "Update failed! title, description, includes, intended, color, material, price fileds are required!"};
        // }

        sql:ParameterizedQuery query = `UPDATE catalog SET 
        title = ${catalogInfo.title}, description=${catalogInfo.description},includes=${catalogInfo.includes},
        intended=${catalogInfo.intended},color=${catalogInfo.color},material=${catalogInfo.material},price=${catalogInfo.price} 
        WHERE id=${catalogInfo.id}`;
        sql:ExecutionResult updateCatalogRes = check self.mySqlClient->execute(query);

        if updateCatalogRes.affectedRowCount != 0 {
            log:printInfo("affectedRowCount: ", affectedRowCount = updateCatalogRes.affectedRowCount.toString());
            return {"affectedRowCount: ": updateCatalogRes.affectedRowCount.toString()};
        } else {
            log:printError("Error while updating catalog: ", updateCatalogRes = updateCatalogRes);
            return error("Error while updating catalog!");
        }
    }

    resource function post addCart(@http:Payload Cart cartInfo) returns json|error {
        // if cartInfo.userId == "" || cartInfo.catalogId.toString() != "" || cartInfo.quantity == "" || cartInfo.cardDetails == "" {
        //     return {"Message": "Insertion failed! userId, catalogId, quantity, cardDetails, checkedOut fileds are required!"};
        // }

        sql:ParameterizedQuery query = `INSERT INTO cart (userId, catalogId, quantity, cardDetails, checkedOut) VALUES (${cartInfo.userId}, ${cartInfo.catalogId}, ${cartInfo.quantity}, ${cartInfo.cardDetails}, ${cartInfo.checkedOut})`;

        sql:ExecutionResult cartResult = check self.mySqlClient->execute(query);

        if cartResult.affectedRowCount != 0 {
            log:printInfo("InsertedId: ", InsertedId = cartResult.lastInsertId.toString());
            return {"InsertedId: ": cartResult.lastInsertId.toString()};
        } else {
            log:printError("Error while inserting data to cart: ", cartResult = cartResult);
            return error("Error while inserting data to cart");
        }
    }

    resource function post updateCart(@http:Payload Cart cartInfo) returns json|error {
        // if cartInfo.userId == "" || cartInfo.catalogId.toString() != "" || cartInfo.quantity == "" || cartInfo.cardDetails == "" {
        //     return {"Message": "Insertion failed! userId, catalogId, quantity, cardDetails, checkedOut fileds are required!"};
        // }

        sql:ParameterizedQuery query = `UPDATE cart SET 
        userId = ${cartInfo.userId}, catalogId=${cartInfo.catalogId},quantity=${cartInfo.quantity},
        cardDetails=${cartInfo.cardDetails},checkedOut=${cartInfo.checkedOut} 
        WHERE id=${cartInfo.id}`;
        sql:ExecutionResult updateCatalogRes = check self.mySqlClient->execute(query);

        if updateCatalogRes.affectedRowCount != 0 {
            log:printInfo("affectedRowCount: ", affectedRowCount = updateCatalogRes.affectedRowCount.toString());
            return {"affectedRowCount: ": updateCatalogRes.affectedRowCount.toString()};
        } else {
            log:printError("Error while updating catalog: ", updateCatalogRes = updateCatalogRes);
            return error("Error while updating catalog!");
        }
    }
}

