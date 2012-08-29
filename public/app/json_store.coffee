(($) ->
  app = $.sammy("#main", ->
    @use "Haml"
    @use "Session"
    @around (callback) ->
      context = this
      @load("/items.json").then((items) ->
        context.items = items
      ).then callback
      # important for CoffeeScript:
      return

    @get "#/", (context) ->
      context.app.swap ""
      $.each @items, (i, item) ->
        context.render("/item.haml",
          id: i
          item: item
        ).appendTo context.$element()


    @get "#/item/:id", (context) ->
      @item = @items[@params["id"]]
      return @notFound()  unless @item
      @partial "/item_detail.haml"

    @post "#/cart", (context) ->
      item_id = @params["item_id"]
      
      # fetch the current cart
      cart = @session("cart", ->
        {}
      )
      
      # this item is not yet in our cart
      # initialize its quantity with 0
      cart[item_id] = 0  unless cart[item_id]
      cart[item_id] += parseInt(@params["quantity"], 10)
      
      # store the cart
      @session "cart", cart
      @trigger "update-cart"

    @bind "update-cart", ->
      sum = 0
      $.each @session("cart") or {}, (id, quantity) ->
        sum += quantity

      $(".cart-info").find(".cart-items").text(sum).end().animate(paddingTop: "30px").animate paddingTop: "10px"

    @bind "run", ->
	      
      # initialize the cart display
      @trigger "update-cart"
  )
  $ ->
    app.run "#/"

) jQuery