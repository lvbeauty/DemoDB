MARK: - fatalError() vs assertionFailure() vs preconditionfailure()

 fatalError() -> for exiting a program, Unconditionally prints a given message and stops execution.
 assertionFailure() -> for testing, Indicates that an internal sanity check failed.
 preconditionFailure() -> for testing, when checking the precondition, Indicates that a precondition was violated.
 
    1. Using assert() and assertionFailure()
    To verify that a certain condition is true. Per default, this causes a fatal error in debug builds, while being ignored in release builds. It’s therefor not guaranteed that execution will stop if an assert is triggered, so it’s kind of like a severe runtime warning.
 
    2. Using precondition() and preconditionFailure() instead of asserts.
    The key difference is that these are always* evaluated, even in release builds. That means that you have a guarantee that execution will never continue if the condition isn’t met.
 
    3. Calling fatalError()
    — which you have probably seen in Xcode-generated implementations of init(coder:) when subclassing an NSCoding-conforming system class, such as UIViewController. Calling this directly kills your process.

# update:  June 6 Sat

    1. Display a list of Students from the Database
    2. There should be a way to save Student record in the Database
    3. There should be a way to update Student record in the Database
    4. There should be a way to delete Student record in the Database
    5. Follow good UI/UX
    6. using NSFetchedResultsController, NSSortDescriptor, searchBar, and some small things

# Update: June 7 Sun
    
    1. fix bugs ->  delete multiple objects, can not create same id, optimize code
    
# Update: June 8 Mon

    1. add search bar scope
    2. coreData manager 
    3. save image data to core data
    4. optimized the code

# Update: June 9 Tue

    1. add filter with sliding menu
    2. add sort with picker view
    3. coreData light migration
    4. multi-entities
    
# Update: June 10 Wed

CoreData Concurrency
    
    1. mainQueueType
    2. privateQueueType
    3. perform() & performAndWait()
    4.......
