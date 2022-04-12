import 'package:brewery/models/beer.dart';
import 'package:brewery/models/review.dart';
import 'package:brewery/screens/details/bloc/details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:brewery/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ReviewsList extends StatelessWidget {
  final Beer beer;

  ReviewsList({this.beer});

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Anuluj"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = TextButton(
      child: Text("Tak"),
      onPressed: () {
        BlocProvider.of<DetailsBloc>(context).add(
          DeleteReviewEvent(
            beer: this.beer,
            review: this.beer.userBeerReview,
          ),
        );
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Potwierdzenie operacji"),
      content: Text("Czy na pewno chcesz usunać swoją recenzję?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.beer.reviews.isEmpty) {
      return Text("To piwo jeszcze nie ma żadnej opinii...");
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: this.beer.reviews.length,
      itemBuilder: (context, index) {
        Review review = this.beer.reviews[index];
        return ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                "assets/icons/star_fill.svg",
                height: 16,
              ),
              SizedBox(height: kDefaultPadding / 4),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: review.rating.toString() + "/",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: "5\n"),
                  ],
                ),
              ),
            ],
          ),
          title: Text(review.owner.nick),
          subtitle: Text(review.text),
          trailing: (this.beer.userBeerReview != null &&
                  review.id == this.beer.userBeerReview.id)
              ? IconButton(
                  icon: new Icon(Icons.delete_forever, color: Colors.red),
                  tooltip: 'Delete your review',
                  onPressed: () {
                    showAlertDialog(context);
                  },
                )
              : null,
        );
      },
    );
  }
}
