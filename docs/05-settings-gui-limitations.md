# 05 - Settings GUI limitations

`nix-settings-gui` reads `@option` comments from the source and binds each one
to the assignment directly below it. The assignment must be a direct attribute
binding in a module body, or in an attribute set that the module evaluates
directly.

## Annotated options must not live in a list of attribute sets

This fails and the controls will not appear:

```nix
config = lib.mkMerge [
  {
    # @option widget = "switch"; label = "Enable example";
    ojuny.example.enable = true;
  }
  (lib.mkIf active {
    services.example.enable = true;
  })
];
```

The scanner sees a list of expressions, not a sequence of attribute bindings,
so the annotated assignment is never collected.

This works:

```nix
# @option widget = "switch"; label = "Enable example";
ojuny.example.enable = true;

config = lib.mkIf active {
  services.example.enable = true;
};
```

`lib.mkIf` is fine. An annotated assignment may sit directly inside a
conditional attribute set:

```nix
config = lib.mkIf active {
  # @option widget = "switch"; label = "Service";
  services.example.enable = true;
};
```

The rule is about the shape of the surrounding expression, not about the
function that gates it. Avoid lists of attribute sets as the place where
annotated assignments live. `lib.mkMerge` is the common offender, but any list
literal with annotated attribute sets has the same failure mode.

## Other limits

- The GUI edits the assignment's value span; it cannot create an option.
- Dynamic attribute names (`${...}`) are not addressable.
- A value wrapped in `let`, `with` or parentheses is peeled for editing; a
  value wrapped in a function call is not rewritten.
