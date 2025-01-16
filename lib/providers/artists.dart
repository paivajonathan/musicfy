// class FavoriteMealsNotifier extends StateNotifier<List<Meal>>{
//   FavoriteMealsNotifier() : super([]);

//   void toggleMealFavoriteStatus(Meal meal){
// 	  //It checks if the provided meal is already present in the favorite meals list
//     final mealIsFavorite = state.contains(meal);

//     if (mealIsFavorite){
//       //The where clause iterates through the list and keeps only the meals where
//       //...the id is not equal to the provided meal.id. 
//       state = state.where((m) => m.id != meal.id).toList();
//     } else{
//       //The spread operator (...) is used to create a copy of the current state list.
//       //The meal object is appended to the copied list.                                         
//       state = [...state, meal];
//     }
//   }
// }

// final favoriteMealsProvider =
//     StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
//   return FavoriteMealsNotifier();
// });