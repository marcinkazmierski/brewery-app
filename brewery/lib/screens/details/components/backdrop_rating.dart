import 'dart:developer';
import 'package:brewery/screens/details/bloc/details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:brewery/models/beer.dart';
import 'package:rating_dialog/rating_dialog.dart';
import '../../../constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BackdropAndRating extends StatefulWidget {
  final Size size;
  final Beer beer;

  const BackdropAndRating({
    Key? key,
    required this.size,
    required this.beer,
  }) : super(key: key);

  @override
  State<BackdropAndRating> createState() => _BackdropAndRatingState();
}

class _BackdropAndRatingState extends State<BackdropAndRating> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // 40% of our total height
      height: widget.size.height * 0.4,
      child: Stack(
        children: <Widget>[
          Container(
            height: widget.size.height * 0.4 - 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.beer.backgroundImage),
              ),
            ),
          ),
          // Rating Box
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              // it will cover 90% of our total width
              width: widget.size.width * 0.9,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 50,
                    color: Color(0xFF12153D).withOpacity(0.2),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset("assets/icons/star_fill.svg"),
                        SizedBox(height: kDefaultPadding / 4),
                        (widget.beer.reviews.length > 0)
                            ? RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: "  ${widget.beer.rating}/",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(text: "5\n"),
                                    TextSpan(
                                      text:
                                          "${widget.beer.reviews.length} ocen(y)",
                                      style: TextStyle(color: kTextLightColor),
                                    ),
                                  ],
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(text: "brak ocen"),
                                  ],
                                ),
                              ),
                      ],
                    ),
                    // Rate this
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        widget.beer.active
                            ? (widget.beer.userBeerReview != null)
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.redAccent, // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                    child: Text("To piwo już oceniłeś!"),
                                    onPressed: () {},
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.redAccent, // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                    child: Text("Oceń to piwo!"),
                                    onPressed: () {
                                      _showRatingDialog(context);
                                    },
                                    //onPressed: _showRatingDialog,
                                  )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                child: Text(
                                    "Dodaj piwo do zbioru \n i wtedy oceń!",
                                    textAlign: TextAlign.center),
                                onPressed: () {},
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Back Button
          SafeArea(
              child: Container(
            margin:
                EdgeInsets.only(left: kDefaultPadding, top: kDefaultPadding),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(30),
            ),
            child: BackButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home', arguments: widget.beer);
                },
                color: Colors.white),
          )),
        ],
      ),
    );
  }

  // show the rating dialog
  void _showRatingDialog(BuildContext context) {
    final _dialog = RatingDialog(
      title: Text('Oceń to piwo!'),
      message: Text('Wybierz ocenę i dodaj komentarz'),
      initialRating: 5,
      commentHint: 'Twój komentarz...',
      image: Container(
        height: 100,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitHeight, image: NetworkImage(widget.beer.icon))),
      ),
      submitButtonText: 'Wystaw ocenę!',
      onCancelled: () => log('RatingDialog cancelled'),
      onSubmitted: (response) {
        BlocProvider.of<DetailsBloc>(context).add(
          AddNewReviewEvent(
            beer: widget.beer,
            comment: response.comment,
            rating: response.rating.toInt(),
          ),
        );
        log('rating: ${response.rating}, comment: ${response.comment}');
        // TODO: add your own logic
        if (response.rating < 3.0) {
        } else {}
      },
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => _dialog,
    );
  }
}
