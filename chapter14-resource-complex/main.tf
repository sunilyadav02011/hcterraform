terraform {
  
}

variable "planet" {
    type=list
    default = ["mars","earth","moon"]
}

variable "plans" {
      type = map
      default = {
          "plana"="USD 10"
          "planb"="USD 50"
          "planc"="USD 100"
      }
} 

variable "plans_object" {
      type = object({
          plana=string
          planb=string
          planc=string
      })

      default = {
          "plana"="USD 10"
          "planb"="USD 50"
          "planc"="USD 100"
      }
}