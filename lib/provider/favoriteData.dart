import 'package:flutter/material.dart';

class FavoriteData with ChangeNotifier {
  List favoriteCards = [];
  List favoriteCardsId = [];

  putFavoriteCard(id) {
    for (int i = 0; i < favoriteCardsId.length; i++) {
      if (int.parse(favoriteCardsId[i]["productId"]) == int.parse(id)) {
        return favoriteCardsId.removeAt(i);
      }
    }
    favoriteCardsId.add({'productId': id});
    notifyListeners();
  }
  

  changeFavoriteCardId(int id, bool isAdd) {
    for (int i = 0; i < favoriteCards.length; i++) {
      if (int.parse(favoriteCards[i]['id']) == id) {
        int countLike = int.parse(favoriteCards[i]['likesCount']);
        if (isAdd) {
          favoriteCards[i]['likesCount'] = (countLike + 1).toString();
          return countLike + 1;
          
        } else {
          if (countLike == 0) {
            return;
          } else {
            favoriteCards[i]['likesCount'] = (countLike - 1).toString();
            return --countLike;
          }
        }
      }
    }
  }


  deleteFavoriteCard(id) {
    for (int i = 0; i < favoriteCardsId.length; i++) {
      if (int.parse(favoriteCardsId[i]["productId"]) == int.parse(id)) {
        favoriteCardsId.removeAt(i);
      }
    }

    for (int i = 0; i < favoriteCards.length; i++) {
      if (int.parse(favoriteCards[i]["id"]) == int.parse(id)) {
        favoriteCards.removeAt(i);
      }
    }

    notifyListeners();
  }

  setFavoriteCardsId(var arr) {
    favoriteCardsId = arr;
  }

  setFavoriteCards(var arr) {
    favoriteCards = arr;
    notifyListeners();
  }

  getFavoriteCards() {
    return favoriteCards;
  }

  checkFavoriteCard(String id) {
    for (var a in favoriteCardsId) {
      if (int.parse(a["productId"]) == int.parse(id)) {
        return true;
      }
    }
    return false;
  }
}
