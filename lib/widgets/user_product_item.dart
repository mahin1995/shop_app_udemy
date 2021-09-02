import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  /// const UserProductItem({ Key? key }) : super(key: key);
  final String title;
  final String imageUrl;

  UserProductItem(
    this.title,
    this.imageUrl,
  );
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        // child: Image.network(
        //   imageUrl,
        //   width: 50,
        //   height: 50,
        //   fit: BoxFit.cover,
        // ),
        backgroundImage: NetworkImage("$imageUrl"),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.edit),color: Theme.of(context).primaryColor,),
            IconButton(onPressed: (){}, icon: Icon(Icons.delete),color: Theme.of(context).errorColor),
          ],
        ),
      ),
    );
  }
}
