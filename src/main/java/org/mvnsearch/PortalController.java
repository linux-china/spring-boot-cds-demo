package org.mvnsearch;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PortalController {

    @GetMapping("/")
    public String index() {
        return "Hello World!";
    }
}
