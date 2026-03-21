(function(){
    if (!jQuery.validator) {
        return;
    }
    var validNamePat = /\ba\s*n+on+((y|o)mo?u?s)?(ly)?\b/i;
    function valid_name_factory(single) {
        return function(value, element) {
            return this.optional(element) || value.length > 5 && value.match(/\S/) && (value.match(/\s/) || (single && !value.match('.@.'))) && !value.match(validNamePat);
        };
    }
  
    function validKenyaPhone(phone_number, element) {
        // strip formatting
        let p = String(phone_number || "");
        p = p.replace(/\+254\(0\)/g, "+254");
        p = p.replace(/[()\s-]/g, "");
      
        // Convert to a plain digits form we can validate
        // Allowed inputs:
        //  07xxxxxxxx / 01xxxxxxxx
        //  +2547xxxxxxxx / +2541xxxxxxxx
        //  2547xxxxxxxx / 2541xxxxxxxx
        //  002547xxxxxxxx / 002541xxxxxxxx
        if (p.startsWith("+")) p = p.slice(1);
        if (p.startsWith("00")) p = p.slice(2);
      
        // Now p should be either:
        //  - 0[71]xxxxxxxx (10 digits)
        //  - 254[71]xxxxxxxx (12 digits)
        const isLocal = /^0[71]\d{8}$/.test(p);
        const isIntl  = /^254[71]\d{8}$/.test(p);
      
        return this.optional(element) || isLocal || isIntl;
      }
      
      jQuery.validator.addMethod(
        "validKenyaPhone",
        validKenyaPhone,
        translation_strings.phone.keFormat || "Please enter a valid Kenya phone number."
      );
      
})();
