import 'package:brewery/screens/details/bloc/details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:brewery/screens/details/components/backdrop_rating.dart';
import 'package:brewery/screens/details/components/tags.dart';
import 'package:brewery/screens/details/components/title_duration_and_fav_btn.dart';
import 'package:brewery/screens/details/components/reviews_list.dart';
import 'package:brewery/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BeerDetailsFormState();
}

class _BeerDetailsFormState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailsBloc, DetailsState>(
      listener: (context, state) {
        if (state is DetailsFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${state.error}'),
            backgroundColor: Colors.redAccent,
          ));
          BlocProvider.of<DetailsBloc>(context)
              .add(DisplayDetailsEvent(beer: state.beer));
        } else if (state is AddedReviewSuccessfulState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Dzięki za Twoją ocenę!'),
            backgroundColor: Colors.green,
          ));
          BlocProvider.of<DetailsBloc>(context)
              .add(DisplayDetailsEvent(beer: state.beer));
        } else if (state is DeletedReviewSuccessfulState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Usunięto recenzję pomyślnie!'),
            backgroundColor: Colors.green,
          ));
          BlocProvider.of<DetailsBloc>(context)
              .add(DisplayDetailsEvent(beer: state.beer));
        }
      },
      child: BlocBuilder<DetailsBloc, DetailsState>(
        builder: (context, state) {
          return Scaffold(
              body: Stack(
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        colorFilter: new ColorFilter.mode(
                            Colors.white.withOpacity(0.1), BlendMode.dstATop),
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/bg3.jpg"))),
              ),
              Center(
                child: SingleChildScrollView(
                  child: state is DetailsDisplayState
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            BackdropAndRating(
                                size: MediaQuery.of(context).size,
                                beer: state.beer),
                            SizedBox(height: kDefaultPadding / 2),
                            TitleDurationAndFabBtn(beer: state.beer),
                            Tags(beer: state.beer),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: kDefaultPadding / 2,
                                horizontal: kDefaultPadding,
                              ),
                              child: Text(
                                "Opis stylu",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              child: Text(
                                state.beer.description,
                                style: TextStyle(
                                  color: kDescriptionColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: kDefaultPadding / 2,
                                horizontal: kDefaultPadding,
                              ),
                              child: Text(
                                "Chmiele",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              child: Text(
                                state.beer.hops,
                                style: TextStyle(
                                  color: kDescriptionColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: kDefaultPadding / 2,
                                horizontal: kDefaultPadding,
                              ),
                              child: Text(
                                "Słody",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              child: Text(
                                state.beer.malts,
                                style: TextStyle(
                                  color: kDescriptionColor,
                                ),
                              ),
                            ),
                            SizedBox(height: kDefaultPadding),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: kDefaultPadding / 2,
                                horizontal: kDefaultPadding,
                              ),
                              child: Text(
                                "Recenzje",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: kDefaultPadding,
                              ),
                              child: ReviewsList(beer: state.beer),
                            ),
                          ],
                        )
                      : CircularProgressIndicator(),
                ),
              ),
            ],
          ));
        },
      ),
    );
  }
}
