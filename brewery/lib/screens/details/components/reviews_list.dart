import 'package:brewery/models/beer.dart';
import 'package:brewery/models/review.dart';
import 'package:flutter/material.dart';
import 'package:brewery/constants.dart';
import 'package:flutter_svg/svg.dart';

class ReviewsList extends StatelessWidget {
  final Beer beer;

  ReviewsList({this.beer});

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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  review.owner.id ==
                      this.beer.userBeerReview.owner.id) //todo: by review.id
              ? IconButton(
                  icon: new Icon(Icons.delete_forever, color: Colors.red),
                  tooltip: 'Delete your review',
                  onPressed: () {
                    // todo
                    print("TODO");
                  },
                )
              : null,
        );
      },
    );
  }
}
