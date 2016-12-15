## Review by Lois van Vliet 

Code Review voor Femke, door Ayanna

Algemeen:
* Extra print statements weghalen
* Controller namen horen met hoofdletter te beginnen
* niet gebruikte code in comments weghalen 


ViewController:
* Class ViewController misschien LoginViewController noemen, zodat we weten bij welke view je code begint. 

searchRecipesViewController:
* Je hebt in variabelenRecipeRate en recipeUrl gedefinieerd, 
maar in je tableview gebruik je in cellarrowat cell.recipeRate.text = recipeUrl, 
misschien variabele anders benoemen want de connectie tussen rate en url is nu best abstract. 
Vooral omdat je in requestHttp functie ook beide gebruikt is het niet duidelijk welke wat teruggeeft.

recipesListViewController:
  * struct defaultsKeys {
       static let username = "firstStringKey"
      }

    Wat is de “firstStringKey”, probeer je hier een lege string te initialiseren? misschien duidelijker om gewoon “” te gebruiken

  *  if let usernameTest = defaults.string(forKey: defaultsKeys.username) {
            username = usernameTest

      Ik zou een comment hiervoor geven met wat je met je username probeert te doen


detailRecipesViewController:
  * Zelfde als bij struct in recipesListviewcontroller opmerking
  * is nog niet af
