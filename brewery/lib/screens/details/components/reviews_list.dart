import 'package:brewery/models/review.dart';
import 'package:flutter/material.dart';
import 'package:brewery/constants.dart';
import 'package:flutter_svg/svg.dart';

class ReviewsList extends StatelessWidget {
  final List<Review> reviews;

  ReviewsList({this.reviews});

  @override
  Widget build(BuildContext context) {
    if (this.reviews.isEmpty) {
      return Text("To piwo jeszcze nie ma żadnej opinii...");
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: this.reviews.length,
      itemBuilder: (context, index) {
        Review review = this.reviews[index];
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
        );
      },
    );
  }
}
