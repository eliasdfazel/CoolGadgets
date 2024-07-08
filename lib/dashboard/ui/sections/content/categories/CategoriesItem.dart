import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cool_gadgets/dashboard/data/CategoriesDataStructure.dart';
import 'package:cool_gadgets/resources/public/colors_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CategoryItem extends StatefulWidget {

  CategoriesDataStructure categoriesDataStructure;

  CategoryItem({Key? key, required this.categoriesDataStructure}) : super(key: key);

  @override
  State<CategoryItem> createState() => CategoryItemState();
}
class CategoryItemState extends State<CategoryItem> {

  Color backgroundColor = ColorsResources.blue;

  bool aInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {

    SystemNavigator.pop();

    return true;
  }

  @override
  void initState() {
    super.initState();
    debugPrint(widget.categoriesDataStructure.categoryNameValue());

    BackButtonInterceptor.add(aInterceptor);

  }

  @override
  void dispose() {
    super.dispose();

    BackButtonInterceptor.remove(aInterceptor);

  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 237,
      width: 356,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: Container(
          decoration: BoxDecoration(
            color: widget.categoriesDataStructure.categoryColorValue().withOpacity(0.99)
          ),
        )
      )
    );
  }

}