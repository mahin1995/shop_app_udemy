import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  /// const UserProductItem({ Key? key }) : super(key: key);
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(
    this.id,
    this.title,
    this.imageUrl,
  );
  @override
  Widget build(BuildContext context) {
    final scafold=Scaffold.of(context);
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
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id,
                );
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try{
                await Provider.of<Products>(context, listen: false).deleteProduct(id);

                }
                catch(error){
                    scafold.showSnackBar(
                      SnackBar(content: Text("Delete faild",textAlign: TextAlign.center,))
                    );
                }
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
